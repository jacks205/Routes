//
//  Extensions.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GooglePlaces
import Kanna

class RoutesLocation {
    
    let prediction: GMSAutocompletePrediction?
    
    init() {
        prediction = nil
    }
    
    init(prediction: GMSAutocompletePrediction) {
        self.prediction = prediction
    }

    var name: String {
        return prediction?.attributedPrimaryText.string ?? ""
    }
    
    var address: String? {
        return prediction?.attributedSecondaryText?.string
    }
    
    var fullAddress: String? {
        return prediction?.attributedFullText.string
    }
    
    var placeID: String? {
        return prediction?.placeID
    }
    
    func boldNameText(_ boldFont: UIFont, regularFont: UIFont) -> NSMutableAttributedString? {
        return prediction?.boldedPrimaryText(boldFont, regularFont: regularFont)
    }
}

extension GMSAutocompletePrediction {
    func boldedPrimaryText(_ boldFont: UIFont, regularFont: UIFont) -> NSMutableAttributedString? {
        guard let bolded = attributedPrimaryText.mutableCopy() as? NSMutableAttributedString else {
            return nil
        }
        bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, in: NSRange(location: 0, length: bolded.length), options: []) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let font = value == nil ? regularFont : boldFont
            bolded.addAttribute(NSFontAttributeName, value: font, range: range)
        }
        return bolded
    }
}

extension GMSPlacesClient {
    func rx_autocompleteQuery(_ query: String, bounds: GMSCoordinateBounds?, filter: GMSAutocompleteFilter?) -> Observable<[GMSAutocompletePrediction]> {
        return Observable<[GMSAutocompletePrediction]>.create { obs -> Disposable in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.autocompleteQuery(query, bounds: bounds, filter: filter, callback: { (predictions, error) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                defer { obs.onCompleted() }
                guard error == nil else {
                    obs.onError(error!)
                    return
                }
                if let predictions = predictions {
                    obs.onNext(predictions)
                } else {
                    obs.onNext([])
                }
            })
            return Disposables.create()
        }
    }
}

extension UITextView{
    var numberOfLines: Int {
        if let fontUnwrapped = font{
            return Int(contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, metrics: [String: Any]?, views: [UIView]) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: metrics, views: viewsDictionary))
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        addConstraintsWithFormat(format, metrics: nil, views: views)
    }
}

//https://gist.github.com/mmick66/9812223
let centerCellCollectionViewFlowLayoutOffset: CGFloat = 10
class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let rectBounds: CGRect = self.collectionView!.bounds
        let halfWidth: CGFloat = rectBounds.size.width * CGFloat(0.50) - centerCellCollectionViewFlowLayoutOffset
        let proposedContentOffsetCenterX: CGFloat = proposedContentOffset.x + halfWidth
        
        let proposedRect: CGRect = self.collectionView!.bounds
        
        let attributesArray: NSArray = self.layoutAttributesForElements(in: proposedRect)! as NSArray
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        
        for layoutAttributes: Any in attributesArray {
            
            if let _layoutAttributes = layoutAttributes as? UICollectionViewLayoutAttributes {
                
                if _layoutAttributes.representedElementCategory != UICollectionElementCategory.cell {
                    continue
                }
                
                if candidateAttributes == nil {
                    candidateAttributes = _layoutAttributes
                    continue
                }
                
                if fabsf(Float(_layoutAttributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(candidateAttributes!.center.x) - Float(proposedContentOffsetCenterX)) {
                    candidateAttributes = _layoutAttributes
                }
                
            }
        }
        
        if attributesArray.count == 0 {
            return CGPoint(x: proposedContentOffset.x - halfWidth * 2, y: proposedContentOffset.y)
        }
        
        return CGPoint(x: candidateAttributes!.center.x - halfWidth, y: proposedContentOffset.y)
    }
    
}

extension Double {
    func metersToMiles() -> Double {
        return self * 0.000621371
    }
    
    func metersToMilesString() -> String {
        return String(format: "%.1f", metersToMiles()) + " mi"
    }
    
    func secondsToHoursMinutes() -> (Int, Int) {
        return (Int(self) / 3600, Int(self) / 60)
    }
    
    func secondsToHoursMinutesString() -> String {
        let hoursMinutes = secondsToHoursMinutes()
        let hour: String
        switch hoursMinutes.0 {
        case 0:
            hour = ""
        case 1:
            hour = "\(hoursMinutes.0) hour"
        default:
            hour = "\(hoursMinutes.0) hours"
        }
        
        let minute: String
        switch hoursMinutes.1 {
        case 0:
            minute = ""
        case 1:
            minute = "\(hoursMinutes.1) minute"
        default:
            minute = "\(hoursMinutes.1) minutes"
        }
        
        return hour + " " + minute
    }
    
}

extension RouteLeg {
    
    private func priorityQueueOrdered(maneuvers: [RouteManeuver]) -> PriorityQueue<RouteManeuver> {
        let queue = PriorityQueue<RouteManeuver> { (new, old) -> Bool in
            return new.length > old.length
        }
        let _ = maneuvers.map { queue.push($0) }
        return queue
    }
    
    func longestManeuver(maneuvers: [RouteManeuver]) -> (RouteManeuver?, RouteManeuver?) {
        let queue = priorityQueueOrdered(maneuvers: maneuvers)
        return (queue.pop(), queue.pop())
    }
    
    func longestManeuverStreets(maneuvers: [RouteManeuver]) -> (String?, String?) {
        let longestManeuvers = longestManeuver(maneuvers: maneuvers)
        return (longestManeuvers.0?.parseNextStreet(), longestManeuvers.1?.parseNextStreet())
    }
    
    func longestManeuverStreets() -> (String?, String?) {
        return longestManeuverStreets(maneuvers: maneuver)
    }
}

extension RouteManeuver {
    
    func parseNextStreet() -> String? {
        if let doc = HTML(html: instruction, encoding: .utf8) {
            return doc.css("span").filter { element -> Bool in
                return element.className == "number" || element.className == "next-street"
            }
            .map { $0.text }[0]
        }
        return nil
    }
    
}


