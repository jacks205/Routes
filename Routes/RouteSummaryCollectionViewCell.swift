//
//  RouteSummaryCollectionViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class RouteSummaryCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = bottomGradientBackgroundColor
            } else {
                backgroundColor = progressBarViewBackgroundColor
            }
        }
    }
    
    static let cellSizePercentage: CGFloat = 0.85
    static var cellSizeDifference: CGFloat {
        get {
            return 1 - cellSizePercentage
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
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    let destinationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 14)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    fileprivate let arrowImageView: UIImageView = {
        let ai = UIImageView(image: UIImage(named: "route-arrow"))
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.tintColor = bottomGradientBackgroundColor
        return ai
    }()
    
    fileprivate let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "DISTANCE"
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    fileprivate let timeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "TIME"
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    let distanceValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    let timeValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans", size: 12)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    fileprivate let viaLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Montserrat-Regular", size: 12)
        lb.text = "VIA"
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        return lb
    }()
    
    let viaValueLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "OpenSans-Semibold", size: 14)
        lb.textColor = UIColor.white
        lb.textAlignment = .center
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
    
    fileprivate var originLabelHeightConstraint: NSLayoutConstraint?
    fileprivate var destinationLabelHeightConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if originLabelHeightConstraint == nil && destinationLabelHeightConstraint == nil {
            originLabel.sizeToFit()
            destinationLabel.sizeToFit()
            originLabelHeightConstraint = originLabel.heightAnchor.constraint(equalToConstant: originLabel.frame.height)
            destinationLabelHeightConstraint = destinationLabel.heightAnchor.constraint(equalToConstant: destinationLabel.frame.height)
            originLabelHeightConstraint?.isActive = true
            destinationLabelHeightConstraint?.isActive = true
        }
        
    }
    
    fileprivate func setConstraints() {
        let mapHeight = frame.size.height * 0.4
        let mapHeightMetric = ["mapHeight": mapHeight]
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: mapView)
        addConstraintsWithFormat("V:|-10-[v1(mapHeight)]-16-[v0]", metrics: mapHeightMetric, views: [distanceLabel, mapView])
        addConstraintsWithFormat("V:[v1]-16-[v0]", metrics: nil, views: [timeLabel, mapView])
        
        addConstraintsWithFormat("V:[v0]-0-[v1]", distanceValueLabel, views: distanceLabel)
        addConstraintsWithFormat("H:|-48-[v0]", views: distanceLabel)
        distanceValueLabel.centerXAnchor.constraint(equalTo: distanceLabel.centerXAnchor, constant: 0).isActive = true
        
        addConstraintsWithFormat("V:[v0]-0-[v1]", timeValueLabel, views: timeLabel)
        addConstraintsWithFormat("H:[v0]-48-|", views: timeLabel)
        timeValueLabel.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor, constant: 0).isActive = true
        
        addConstraintsWithFormat("V:[v0]-8-[v1]", viaLabel, views: distanceValueLabel)
        addConstraintsWithFormat("V:[v0]-0-[v1]", viaValueLabel, views: viaLabel)
        viaLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        viaValueLabel.centerXAnchor.constraint(equalTo: viaLabel.centerXAnchor, constant: 0).isActive = true
        
        originLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        originLabel.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.9).isActive = true
        if UIApplication.shared.keyWindow?.rootViewController?.view.frame.width > 320 {
            originLabel.topAnchor.constraint(equalTo: viaValueLabel.bottomAnchor, constant: 32).isActive = true
        } else {
            originLabel.topAnchor.constraint(equalTo: viaValueLabel.bottomAnchor, constant: 24).isActive = true
        }
        
        arrowImageView.widthAnchor.constraint(equalToConstant: arrowImageView.frame.width).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: arrowImageView.frame.height).isActive = true
        arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        arrowImageView.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 12).isActive = true
        
        destinationLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 12).isActive = true
        destinationLabel.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
}
