//
//  RouteTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    let arrowImageView: UIImageView = {
        let ai = UIImageView(image: UIImage(named: "route-arrow"))
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    let carImageView: UIImageView = {
        let ai = UIImageView(image: UIImage(named: "car"))
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    let originNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans", size: 15)
        lb.textColor = UIColor.whiteColor()
        return lb
    }()
    
    let destinationNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans", size: 15)
        lb.textColor = UIColor.whiteColor()
        return lb
    }()
    
    let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans-Light", size: 12)
        lb.textColor = UIColor.lightGrayColor()
        return lb
    }()
    
    let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans-Light", size: 28)
        lb.textColor = UIColor.whiteColor()
        return lb
    }()
    
    var progressBarView: RouteProgressBarView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProgressBarView()
        addSubview(progressBarView)
        addSubview(originNameLabel)
        addSubview(destinationNameLabel)
        addSubview(arrowImageView)
        addSubview(carImageView)
        addSubview(descriptionLabel)
        addSubview(distanceLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        progressBarView.layoutIfNeeded()
        createLineLayer()
    }
    
    func setupProgressBarView() {
        progressBarView = RouteProgressBarView(frame: CGRect(x: 0, y: 0, width: frame.width / 2.5, height: frame.height / 5))
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.layer.cornerRadius = 15
        progressBarView.progressLayer.cornerRadius = 15
        progressBarView.clipsToBounds = true
    }
    
    func updateProgressBarView(percentage: Double, color: UIColor, text: String) {
        progressBarView.updateProgressView(percentage, color: color, text: text)
    }
    
    private func createLineLayer() {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: progressBarView.frame.origin.x + progressBarView.frame.width / 2, y: progressBarView.frame.origin.y + progressBarView.frame.height / 2)
        path.moveToPoint(startPoint)
        startPoint.x = frame.width
        path.addLineToPoint(startPoint)
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.CGPath
        lineLayer.lineWidth = 1
        lineLayer.strokeColor = progressBarViewBackgroundColor.CGColor
        lineLayer.backgroundColor = progressBarViewBackgroundColor.CGColor
        layer.insertSublayer(lineLayer, atIndex: 0)
    }
    
    private func setConstraints() {
        originNameLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 10).active = true
        originNameLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10).active = true
        
        arrowImageView.leadingAnchor.constraintEqualToAnchor(originNameLabel.trailingAnchor, constant: 10).active = true
        arrowImageView.centerYAnchor.constraintEqualToAnchor(originNameLabel.centerYAnchor, constant: 0).active = true
        
        destinationNameLabel.leadingAnchor.constraintEqualToAnchor(arrowImageView.trailingAnchor, constant: 10).active = true
        destinationNameLabel.centerYAnchor.constraintEqualToAnchor(originNameLabel.centerYAnchor, constant: 0).active = true
        
        carImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10).active = true
        carImageView.topAnchor.constraintEqualToAnchor(originNameLabel.bottomAnchor, constant: 12).active = true
        
        descriptionLabel.leadingAnchor.constraintEqualToAnchor(carImageView.trailingAnchor, constant: 8).active = true
        descriptionLabel.centerYAnchor.constraintEqualToAnchor(carImageView.centerYAnchor, constant: 0).active = true
        
        distanceLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10).active = true
        distanceLabel.topAnchor.constraintEqualToAnchor(carImageView.bottomAnchor, constant: 10).active = true
        
        progressBarView.topAnchor.constraintEqualToAnchor(distanceLabel.bottomAnchor, constant: 10).active = true
        progressBarView.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 10).active = true
        progressBarView.widthAnchor.constraintEqualToAnchor(widthAnchor, multiplier: 1/2.5, constant: 0).active = true
        progressBarView.heightAnchor.constraintEqualToConstant(30).active = true
    }
    
}
