//
//  RouteSummaryCollectionViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteSummaryCollectionViewCell: UICollectionViewCell {
    
    override var selected: Bool {
        didSet {
            if selected {
                backgroundColor = bottomGradientBackgroundColor
            } else {
                backgroundColor = progressBarViewBackgroundColor
            }
        }
    }
    
    let mapView: UIView = {
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = lightRedColor
        return mv
    }()
    
    let startingLocationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    let destinationLocationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    private let arrowImageView: UIImageView = {
        let ai = UIImageView(image: UIImage(named: "route-arrow"))
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.tintColor = bottomGradientBackgroundColor
        return ai
    }()
    
    private let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "DISTANCE"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    private let timeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "TIME"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    let distanceValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    let timeValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        addSubview(startingLocationLabel)
        addSubview(arrowImageView)
        addSubview(destinationLocationLabel)
        addSubview(distanceLabel)
        addSubview(distanceValueLabel)
        addSubview(timeLabel)
        addSubview(timeValueLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startingLocationLabel.sizeToFit()
        destinationLocationLabel.sizeToFit()
    }
    
    private func setConstraints() {
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: mapView)
        addConstraintsWithFormat("V:|-10-[v1(128)]-10-[v0]", views: startingLocationLabel, mapView)
        startingLocationLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        arrowImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        arrowImageView.topAnchor.constraintEqualToAnchor(startingLocationLabel.bottomAnchor, constant: 10).active = true
        destinationLocationLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        destinationLocationLabel.topAnchor.constraintEqualToAnchor(arrowImageView.bottomAnchor, constant: 10).active = true
        
        addConstraintsWithFormat("V:[v0]-0-[v1]-16-|", views: distanceLabel, distanceValueLabel)
        addConstraintsWithFormat("H:|-48-[v0]", views: distanceLabel)
        distanceValueLabel.centerXAnchor.constraintEqualToAnchor(distanceLabel.centerXAnchor, constant: 0).active = true
        
        addConstraintsWithFormat("V:[v0]-0-[v1]-16-|", views: timeLabel, timeValueLabel)
        addConstraintsWithFormat("H:[v0]-48-|", views: timeLabel)
        timeValueLabel.centerXAnchor.constraintEqualToAnchor(timeLabel.centerXAnchor, constant: 0).active = true
    }
    
}
