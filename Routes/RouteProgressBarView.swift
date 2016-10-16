//
//  RouteProgressBarView.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteProgressBarView: UIView, CAAnimationDelegate {
    
    let progressLayer = CAShapeLayer()
    
    fileprivate var lastProgressValue = 0.0
    fileprivate var lastProgressColor = UIColor.clear
    
    var animationDuration = 3.0
    var animationTimingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1.0, 0.32, 1.0)
    
    let textLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        lastProgressColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgressLayer(lastProgressColor)
        addSubview(textLabel)
        backgroundColor = progressBarViewBackgroundColor
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        createProgressLayerPath()
    }
    
    func updateProgressView(_ percentage: Double, color: UIColor, text: String) {
        animateProgressLayer(percentage)
        animateProgressLayerColor(color)
        textLabel.text = text
        lastProgressValue = percentage
        lastProgressColor = color
    }
    
    fileprivate func createProgressLayerPath() {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: 0, y: frame.height / 2)
        path.move(to: startPoint)
        startPoint.x = startPoint.x + frame.width
        path.addLine(to: startPoint)
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = frame.height
    }
    
    fileprivate func createProgressLayer(_ startColor: UIColor) {
        createProgressLayerPath()
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeColor = startColor.cgColor
        progressLayer.fillColor = startColor.cgColor
        progressLayer.backgroundColor = UIColor.clear.cgColor
        layer.insertSublayer(progressLayer, at: 0)
    }
    
    fileprivate func animateProgressLayer(_ percentage: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = lastProgressValue
        animation.toValue = percentage
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = animationTimingFunction
        progressLayer.add(animation, forKey: "strokeEnd")
    }
    
    fileprivate func animateProgressLayerColor(_ color: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = lastProgressColor.cgColor
        animation.toValue = color.cgColor
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = animationTimingFunction
        progressLayer.add(animation, forKey: "strokeColor")
    }
    
    fileprivate func setConstraints() {
        let margins = layoutMarginsGuide
        textLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }

}
