//
//  RouteSummaryRenameView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteSummaryRenameView: UIView {
    
    let originRenameView: RouteRenameTextView = {
        let v = RouteRenameTextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let destinationRenameView: RouteRenameTextView = {
        let v = RouteRenameTextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "arrow")
        iv.tintColor = UIColor.white.withAlphaComponent(0.5)
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(originRenameView)
        addSubview(destinationRenameView)
        addSubview(arrowImageView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        arrowImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        addConstraintsWithFormat("H:|[v0]-8-[v1]", views: originRenameView, arrowImageView)
        addConstraintsWithFormat("V:[v0]-8-[v1]", views: originRenameView, arrowImageView)
        
        arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        destinationRenameView.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor).isActive = true
        destinationRenameView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        destinationRenameView.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 0).isActive = true
//        addConstraintsWithFormat("V:[v0]|", views: destinationRenameView)
        
        let editIV1 = UIImageView(image: #imageLiteral(resourceName: "edit-pencil"))
        editIV1.translatesAutoresizingMaskIntoConstraints = false
        editIV1.tintColor = .white
        
        let editIV2 = UIImageView(image: #imageLiteral(resourceName: "edit-pencil"))
        editIV2.translatesAutoresizingMaskIntoConstraints = false
        editIV2.tintColor = .white
        
        addSubview(editIV1)
        addSubview(editIV2)
        
        editIV1.leadingAnchor.constraint(equalTo: originRenameView.trailingAnchor, constant: 3).isActive = true
        editIV1.bottomAnchor.constraint(equalTo: originRenameView.bottomAnchor, constant: -3).isActive = true
        editIV1.heightAnchor.constraint(equalToConstant: 11).isActive = true
        editIV1.widthAnchor.constraint(equalToConstant: 11).isActive = true
        
        editIV2.leadingAnchor.constraint(equalTo: destinationRenameView.trailingAnchor, constant: 3).isActive = true
        editIV2.bottomAnchor.constraint(equalTo: destinationRenameView.bottomAnchor, constant: -3).isActive = true
        editIV2.heightAnchor.constraint(equalToConstant: 11).isActive = true
        editIV2.widthAnchor.constraint(equalToConstant: 11).isActive = true
        
    }
    
}
