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
    
    let originLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 14)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    let destinationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 14)
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
    
    private let viaLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "VIA"
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    let viaValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans-Semibold", size: 14)
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        addSubview(originLabel)
        addSubview(arrowImageView)
        addSubview(destinationLabel)
        addSubview(distanceLabel)
        addSubview(distanceValueLabel)
        addSubview(timeLabel)
        addSubview(timeValueLabel)
        addSubview(viaLabel)
        addSubview(viaValueLabel)
        setConstraints()
    }
    
    private var originLabelHeightConstraint: NSLayoutConstraint?
    private var destinationLabelHeightConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if originLabelHeightConstraint == nil && destinationLabelHeightConstraint == nil {
            originLabel.sizeToFit()
            destinationLabel.sizeToFit()
            originLabelHeightConstraint = originLabel.heightAnchor.constraintEqualToConstant(originLabel.frame.height)
            destinationLabelHeightConstraint = destinationLabel.heightAnchor.constraintEqualToConstant(destinationLabel.frame.height)
            originLabelHeightConstraint?.active = true
            destinationLabelHeightConstraint?.active = true
        }
        
    }
    
    private func setConstraints() {
        let mapHeight = frame.size.height * 0.4
        let mapHeightMetric = ["mapHeight": mapHeight]
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: mapView)
        addConstraintsWithFormat("V:|-10-[v1(mapHeight)]-16-[v0]", metrics: mapHeightMetric, views: [distanceLabel, mapView])
        addConstraintsWithFormat("V:[v1]-16-[v0]", metrics: nil, views: [timeLabel, mapView])
        
        addConstraintsWithFormat("V:[v0]-0-[v1]", views: distanceLabel, distanceValueLabel)
        addConstraintsWithFormat("H:|-48-[v0]", views: distanceLabel)
        distanceValueLabel.centerXAnchor.constraintEqualToAnchor(distanceLabel.centerXAnchor, constant: 0).active = true
        
        addConstraintsWithFormat("V:[v0]-0-[v1]", views: timeLabel, timeValueLabel)
        addConstraintsWithFormat("H:[v0]-48-|", views: timeLabel)
        timeValueLabel.centerXAnchor.constraintEqualToAnchor(timeLabel.centerXAnchor, constant: 0).active = true
        
        addConstraintsWithFormat("V:[v0]-8-[v1]", views: distanceValueLabel, viaLabel)
        addConstraintsWithFormat("V:[v0]-0-[v1]", views: viaLabel, viaValueLabel)
        viaLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        viaValueLabel.centerXAnchor.constraintEqualToAnchor(viaLabel.centerXAnchor, constant: 0).active = true
        
        originLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        originLabel.widthAnchor.constraintEqualToAnchor(mapView.widthAnchor, multiplier: 0.9).active = true
        if UIApplication.sharedApplication().keyWindow?.rootViewController?.view.frame.width > 320 {
            originLabel.topAnchor.constraintEqualToAnchor(viaValueLabel.bottomAnchor, constant: 32).active = true
        } else {
            originLabel.topAnchor.constraintEqualToAnchor(viaValueLabel.bottomAnchor, constant: 24).active = true
        }
        
        arrowImageView.widthAnchor.constraintEqualToConstant(arrowImageView.frame.width).active = true
        arrowImageView.heightAnchor.constraintEqualToConstant(arrowImageView.frame.height).active = true
        arrowImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        arrowImageView.topAnchor.constraintEqualToAnchor(originLabel.bottomAnchor, constant: 12).active = true
        
        destinationLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor, constant: 0).active = true
        destinationLabel.topAnchor.constraintEqualToAnchor(arrowImageView.bottomAnchor, constant: 12).active = true
        destinationLabel.widthAnchor.constraintEqualToAnchor(mapView.widthAnchor, multiplier: 0.9).active = true
        
        
        
    }
    
}
