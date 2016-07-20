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
import GoogleMaps
import MapboxStatic

extension Snapshot {
    func rx_image() -> Observable<UIImage?> {
        return Observable<UIImage?>.create { obs -> Disposable in
            let task = self.image { (image, error) in
                defer { obs.onCompleted() }
                guard error == nil else {
                    obs.onError(error!)
                    return
                }
                obs.onNext(image)
            }
            task.resume()
            return AnonymousDisposable { task.cancel() }
        }
    }
}

class RoutesLocation {
    
    let prediction: GMSAutocompletePrediction
    
    init(prediction: GMSAutocompletePrediction) {
        self.prediction = prediction
    }

    var name: String {
        return prediction.attributedPrimaryText.string
    }
    
    var address: String? {
        return prediction.attributedSecondaryText?.string
    }
    
    var fullAddress: String? {
        return prediction.attributedFullText.string
    }
    
    var placeID: String? {
        return prediction.placeID
    }
    
    func boldNameText(boldFont: UIFont, regularFont: UIFont) -> NSMutableAttributedString? {
        return prediction.boldedPrimaryText(boldFont, regularFont: regularFont)
    }
}

extension GMSAutocompletePrediction {
    func boldedPrimaryText(boldFont: UIFont, regularFont: UIFont) -> NSMutableAttributedString? {
        guard let bolded = attributedPrimaryText.mutableCopy() as? NSMutableAttributedString else {
            return nil
        }
        bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSRange(location: 0, length: bolded.length), options: []) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let font = value == nil ? regularFont : boldFont
            bolded.addAttribute(NSFontAttributeName, value: font, range: range)
        }
        return bolded
    }
}

extension GMSPlacesClient {
    func rx_autocompleteQuery(query: String, bounds: GMSCoordinateBounds?, filter: GMSAutocompleteFilter?) -> Observable<[GMSAutocompletePrediction]> {
        return Observable<[GMSAutocompletePrediction]>.create { obs -> Disposable in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.autocompleteQuery(query, bounds: bounds, filter: filter, callback: { (predictions, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
            return NopDisposable.instance
        }
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, metrics: [String: AnyObject]?, views: [UIView]) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: metrics, views: viewsDictionary))
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        addConstraintsWithFormat(format, metrics: nil, views: views)
    }
}

//https://gist.github.com/mmick66/9812223
class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let rectBounds: CGRect = self.collectionView!.bounds
        let halfWidth: CGFloat = rectBounds.size.width * CGFloat(0.50)
        let proposedContentOffsetCenterX: CGFloat = proposedContentOffset.x + halfWidth
        
        let proposedRect: CGRect = self.collectionView!.bounds
        
        let attributesArray: NSArray = self.layoutAttributesForElementsInRect(proposedRect)!
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        
        for layoutAttributes: AnyObject in attributesArray {
            
            if let _layoutAttributes = layoutAttributes as? UICollectionViewLayoutAttributes {
                
                if _layoutAttributes.representedElementCategory != UICollectionElementCategory.Cell {
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
