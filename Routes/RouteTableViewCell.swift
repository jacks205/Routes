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
        lb.textColor = UIColor.white
        return lb
    }()
    
    let destinationNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans", size: 15)
        lb.textColor = UIColor.white
        return lb
    }()
    
    let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans-Light", size: 12)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans-Light", size: 28)
        lb.textColor = UIColor.white
        return lb
    }()
    
    var progressBarView: RouteProgressBarView!
    var lineLayer: CAShapeLayer?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if lineLayer == nil {
            createLineLayer()
        }
    }
    
    func setupProgressBarView() {
        progressBarView = RouteProgressBarView(frame: CGRect(x: 0, y: 0, width: frame.width / 2.5, height: frame.height / 5))
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.layer.cornerRadius = 15
        progressBarView.progressLayer.cornerRadius = 15
        progressBarView.clipsToBounds = true
    }
    
    func updateProgressBarView(_ percentage: Double, color: UIColor, text: String) {
        progressBarView.updateProgressView(percentage, color: color, text: text)
    }
    
    fileprivate func createLineLayer() {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: progressBarView.frame.origin.x + progressBarView.frame.width / 2, y: progressBarView.frame.origin.y + progressBarView.frame.height / 2)
        path.move(to: startPoint)
        startPoint.x = frame.width
        path.addLine(to: startPoint)
        lineLayer = CAShapeLayer()
        lineLayer?.path = path.cgPath
        lineLayer?.lineWidth = 1
        lineLayer?.strokeColor = progressBarViewBackgroundColor.cgColor
        lineLayer?.backgroundColor = progressBarViewBackgroundColor.cgColor
        layer.insertSublayer(lineLayer!, at: 0)
    }
    
    fileprivate func setConstraints() {
        originNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        originNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        arrowImageView.leadingAnchor.constraint(equalTo: originNameLabel.trailingAnchor, constant: 10).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: originNameLabel.centerYAnchor, constant: 0).isActive = true
        
        destinationNameLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 10).isActive = true
        destinationNameLabel.centerYAnchor.constraint(equalTo: originNameLabel.centerYAnchor, constant: 0).isActive = true
        
        carImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        carImageView.topAnchor.constraint(equalTo: originNameLabel.bottomAnchor, constant: 12).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 8).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: carImageView.centerYAnchor, constant: 0).isActive = true
        
        distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: 10).isActive = true
        
        progressBarView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10).isActive = true
        progressBarView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        progressBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2.5, constant: 0).isActive = true
        progressBarView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
