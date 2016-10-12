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
    
    private var lastProgressValue = 0.0
    private var lastProgressColor = UIColor.clearColor()
    
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
    
    func updateProgressView(percentage: Double, color: UIColor, text: String) {
        animateProgressLayer(percentage)
        animateProgressLayerColor(color)
        textLabel.text = text
        lastProgressValue = percentage
        lastProgressColor = color
    }
    
    private func createProgressLayerPath() {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: 0, y: frame.height / 2)
        path.moveToPoint(startPoint)
        startPoint.x = startPoint.x + frame.width
        path.addLineToPoint(startPoint)
        progressLayer.path = path.CGPath
        progressLayer.lineWidth = frame.height
    }
    
    private func createProgressLayer(startColor: UIColor) {
        createProgressLayerPath()
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeColor = startColor.CGColor
        progressLayer.fillColor = startColor.CGColor
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        layer.insertSublayer(progressLayer, atIndex: 0)
    }
    
    private func animateProgressLayer(percentage: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = lastProgressValue
        animation.toValue = percentage
        animation.duration = animationDuration
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = animationTimingFunction
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
    }
    
    private func animateProgressLayerColor(color: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = lastProgressColor.CGColor
        animation.toValue = color.CGColor
        animation.duration = animationDuration
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = animationTimingFunction
        progressLayer.addAnimation(animation, forKey: "strokeColor")
    }
    
    private func setConstraints() {
        let margins = layoutMarginsGuide
        textLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 10).active = true
        textLabel.centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor).active = true
    }

}
