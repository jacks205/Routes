//
//  RouteSummaryOverlayCollectionViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteSummaryOverlayCollectionViewCell: UICollectionViewCell {
    
    static let cellSizePercentage: CGFloat = 0.85
    static var cellSizeDifference: CGFloat {
        get {
            return 1 - cellSizePercentage
        }
    }
    
    let detailView: RouteSummaryDetailView = {
        let v = RouteSummaryDetailView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 2
        v.backgroundColor = bottomGradientBackgroundColor
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(detailView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        detailView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        detailView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        detailView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        detailView.widthAnchor.constraint(equalToConstant: 254).isActive = true
    }
    
    
    
}
