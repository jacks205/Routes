//
//  ManeuverDetailTableViewCell.swift
//  Routes
//
//  Created by Mark Jackson on 10/20/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class ManeuverDetailTableViewCell: UITableViewCell {
    
    static let identifier: String = "DetailCell"
    
    let detailView: ManeuverDetailView = {
        let v = ManeuverDetailView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = bottomGradientBackgroundColor
        v.layer.cornerRadius = 2
        return v
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(detailView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func setConstraints() {
        addConstraintsWithFormat("V:|-5-[v0]-5-|", views: detailView)
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: detailView)
    }

}
