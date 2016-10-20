//
//  ManeuverDetailView.swift
//  Routes
//
//  Created by Mark Jackson on 10/19/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class ManeuverDetailView: UIView {
    
    let textLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        l.tintColor = .white
        l.font = UIFont.montserratRegular(size: 12)
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
        l.font = UIFont.openSansLight(size: 10)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        addSubview(timeLabel)
        addSubview(distanceLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        let pin: UIImageView = {
            let iv = UIImageView(image: #imageLiteral(resourceName: "pin-detail"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            return iv
        }()
        addSubview(pin)
        pin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        pin.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pin.widthAnchor.constraint(equalToConstant: 25).isActive = true
        pin.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        textLabel.leadingAnchor.constraint(equalTo: pin.trailingAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addConstraintsWithFormat("H:[v0]-10-[v1]", views: textLabel, timeLabel)
        let top = textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10)
        top.priority = UILayoutPriorityRequired
        top.isActive = true
        let bot = textLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        bot.priority = UILayoutPriorityRequired
        bot.isActive = true
        textLabel.setContentHuggingPriority(250, for: .horizontal)
        timeLabel.setContentCompressionResistancePriority(252, for: .horizontal)
    }

}

extension ManeuverDetailView {
    
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
