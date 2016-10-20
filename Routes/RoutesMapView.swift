//
//  RoutesMapView.swift
//  Routes
//
//  Created by Mark Jackson on 10/19/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import MapKit

class RoutesMapView: MKMapView {
    
    private let lineLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.lineWidth = 8
        return l
    }()
    
    var lineColor: UIColor {
        get {
            return UIColor(cgColor: lineLayer.strokeColor!)
        }
        set {
            lineLayer.strokeColor = newValue.cgColor
        }
    }
    
    init(lineColor: UIColor) {
        super.init(frame: .zero)
        self.lineColor = lineColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        lineLayer.removeFromSuperlayer()
        lineLayer.frame = bounds
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        lineLayer.path = path.cgPath
        layer.addSublayer(lineLayer)
    }

}
