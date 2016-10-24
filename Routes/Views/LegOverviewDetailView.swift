//
//  LegOverviewDetailView.swift
//  Routes
//
//  Created by Mark Jackson on 10/24/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class LegOverviewDetailView: UIView {
    
    let originLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.montserratRegular(size: 12)
        l.numberOfLines = 0
        return l
    }()
    
    let destinationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.montserratRegular(size: 12)
        l.numberOfLines = 0
        return l
    }()
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.openSansLight(size: 14)
        return l
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.openSansLight(size: 12)
        return l
    }()
    
    let pin: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pin-detail"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(originLabel)
        addSubview(destinationLabel)
        addSubview(timeLabel)
        addSubview(distanceLabel)
        addSubview(pin)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        pin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        pin.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pin.widthAnchor.constraint(equalToConstant: 25).isActive = true
        pin.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        
        let arrow: UIImageView = {
            let iv = UIImageView(image: #imageLiteral(resourceName: "arrow"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            return iv
        }()
        addSubview(arrow)
        
        originLabel.leadingAnchor.constraint(equalTo: pin.trailingAnchor, constant: 10).isActive = true
        arrow.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: 8).isActive = true
        destinationLabel.leadingAnchor.constraint(equalTo: arrow.trailingAnchor, constant: 8).isActive = true
        
        originLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        destinationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        destinationLabel.trailingLessThanOrEqual(anchor: timeLabel.leadingAnchor, constant: -10, priority: UILayoutPriorityDefaultLow, isActive: true)
        
        originLabel.bottomEqual(anchor: bottomAnchor, constant: -10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        destinationLabel.bottomEqual(anchor: bottomAnchor, constant: -10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        originLabel.topEqual(anchor: topAnchor, constant: 10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        destinationLabel.topEqual(anchor: topAnchor, constant: 10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        
        timeLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        
        originLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        destinationLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
//        originLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
//        destinationLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        originLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.3).isActive = true
    }
}
