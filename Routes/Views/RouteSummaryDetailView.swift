//
//  RouteSummaryDetailView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteSummaryDetailView: UIView {
    
    let viaLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Montserrat-Regular", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Montserrat-Regular", size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = lightBlueColorText
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(viaLabel)
        addSubview(distanceLabel)
        addSubview(timeLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        viaLabel.sizeToFit()
    }
    
    func setConstraints() {
        viaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        viaLabel.centerYEqual(view: self)
        
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true

        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addConstraintsWithFormat("H:[v0]->=10@250-[v1]", views: viaLabel, distanceLabel)
        addConstraintsWithFormat("H:[v0]->=10@250-[v1]", views: viaLabel, timeLabel)
        
        distanceLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        timeLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        viaLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
    }

}
