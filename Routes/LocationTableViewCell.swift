//
//  LocationTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    let pinImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "pin"))
        piv.translatesAutoresizingMaskIntoConstraints = false
        return piv
    }()
    
    let locationNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "OpenSans-Semibold", size: 14)
        lb.textColor = UIColor.whiteColor()
        return lb
    }()
    
    let addressLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 2
        lb.font = UIFont(name: "OpenSans-Light", size: 12)
        lb.textColor = UIColor.lightGrayColor()
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(pinImageView)
        addSubview(locationNameLabel)
        addSubview(addressLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        pinImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 16).active = true
        pinImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        
        locationNameLabel.leadingAnchor.constraintEqualToAnchor(pinImageView.trailingAnchor, constant: 16).active = true
        locationNameLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 8).active = true
        
        addressLabel.leadingAnchor.constraintEqualToAnchor(pinImageView.trailingAnchor, constant: 16).active = true
        addressLabel.topAnchor.constraintEqualToAnchor(locationNameLabel.bottomAnchor, constant: 0).active = true
    }

}
