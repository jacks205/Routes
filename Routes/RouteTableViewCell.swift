//
//  RouteTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    var progressBarView: RouteProgressBarView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        progressBarView = RouteProgressBarView(frame: frame)
        addSubview(progressBarView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func updateProgressBarView(percentage: Double, color: UIColor, text: String) {
        progressBarView.updateProgressView(percentage, color: color, text: text)
    }
    
    private func setConstraints() {
        progressBarView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        progressBarView.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        progressBarView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        progressBarView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    }
    
}
