//
//  ShowDirectionView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShowDirectionView: UIView {
    
    let showDirectionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Montserrat-Regular", size: 12)
        lbl.textColor = .white
        lbl.text = "Show Directions"
        return lbl
    }()
    
    let menuImageView: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.image = UIImage(named: "hamburger")
        return im
    }()
    
    let btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(showDirectionsLabel)
        addSubview(menuImageView)
        addSubview(btn)
        setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint() {
        menuImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        showDirectionsLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 8).isActive = true
        showDirectionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addConstraintsWithFormat("H:|[v0]|", views: btn)
        addConstraintsWithFormat("V:|[v0]|", views: btn)
    }

}
