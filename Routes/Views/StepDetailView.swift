//
//  ManeuverDetailView.swift
//  Routes
//
//  Created by Mark Jackson on 10/19/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class StepDetailView: UIView {
    
    let textLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.montserratRegular(size: 14)
        l.numberOfLines = 0
        return l
    }()
    
    let timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
//        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.openSansLight(size: 14)
        return l
    }()
    
    let distanceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
//        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.openSansLight(size: 12)
        return l
    }()
    
    let pin: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pin-detail"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        addSubview(timeLabel)
        addSubview(distanceLabel)
        addSubview(pin)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        pin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        pin.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pin.widthAnchor.constraint(equalToConstant: 25).isActive = true
        pin.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        
        textLabel.leadingAnchor.constraint(equalTo: pin.trailingAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.trailingLessThanOrEqual(anchor: timeLabel.leadingAnchor, constant: -10, priority: UILayoutPriorityDefaultLow, isActive: true)
        textLabel.topEqual(anchor: topAnchor, constant: 10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        textLabel.bottomEqual(anchor: bottomAnchor, constant: -10, priority: UILayoutPriorityDefaultHigh, isActive: true)
        timeLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
    }
    
    func setPinImage(type: GoogleManeuverType) {
        switch type {
        default:
            pin.image = #imageLiteral(resourceName: "pin")
        }
    }

}

extension StepDetailView {
    
    func setTextLabelAttributedString(text: String) {
        let newText = text + "<style>body{font-family: Montserrat-Regular; font-size:12px; color:white;}</style>"
        if let data = newText.data(using: .unicode) {
            do {
                let attr = try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                textLabel.attributedText = attr
            }catch {}
        }
    }
    
}
