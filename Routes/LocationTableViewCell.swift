//
//  LocationTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    let regularFont = UIFont(name: "OpenSans-Light", size: 14)!
    let boldFont = UIFont(name: "OpenSans-Semibold", size: 14)!

    let pinImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "pin"))
        piv.translatesAutoresizingMaskIntoConstraints = false
        return piv
    }()
    
    let locationNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.white
        return lb
    }()
    
    let addressLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 2
        lb.font = UIFont(name: "OpenSans-Light", size: 12)
        lb.textColor = locationAddressTextColor
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
    
    func setConstraints() {
        pinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        locationNameLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 16).isActive = true
        locationNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        addressLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 16).isActive = true
        addressLabel.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 0).isActive = true
        addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            addressLabel.textColor = UIColor.white
        } else {
            addressLabel.textColor = locationAddressTextColor
        }
        super.setSelected(selected, animated: animated)
    }

}
