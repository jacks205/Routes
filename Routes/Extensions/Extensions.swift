//
//  Extensions.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
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
