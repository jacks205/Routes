//
//  RouteProgressBarView.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteProgressBarView: UIView {
    
    private let progressLayer = CAShapeLayer()
    
    private var lastProgressValue = 0.0
    private var lastProgressColor = UIColor.clearColor()
    
    var animationDuration = 3.0
    var animationTimingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1.0, 0.32, 1.0)
    
    let textLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = UIColor.purpleColor()
        return lb
    }()

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        lastProgressColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgressLayer(lastProgressColor)
        backgroundColor = UIColor.blueColor()
        addSubview(textLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func updateProgressView(percentage: Double, color: UIColor, text: String) {
        animateProgressLayer(percentage)
        animateProgressLayerColor(color)
        textLabel.text = text
        textLabel.sizeToFit()
        lastProgressValue = percentage
        lastProgressColor = color
    }
    
    private func createProgressLayer(startColor: UIColor) {
        let path = UIBezierPath()
        var startPoint = CGPoint(x: 0, y: frame.height / 2)
        path.moveToPoint(startPoint)
        path.lineWidth = frame.height
        startPoint.x = startPoint.x + frame.width
        path.addLineToPoint(startPoint)
        progressLayer.path = path.CGPath
        progressLayer.strokeColor = startColor.CGColor
        progressLayer.fillColor = startColor.CGColor
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.lineWidth = frame.height
        layer.addSublayer(progressLayer)
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
