//
//  RouteSummaryRenameView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContainerView: UIView {
    
    let leftView: TextContainerView = {
        let v = TextContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let rightView: TextContainerView = {
        let v = TextContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    var rx_viewTap: Observable<String> {
        return Observable.from([rightView.rx_tap, leftView.rx_tap])
            .merge()
            .shareReplayLatestWhileConnected()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftView)
        addSubview(rightView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        leftView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let arrow: UIImageView = {
            let i = UIImageView(image: #imageLiteral(resourceName: "arrow"))
            i.translatesAutoresizingMaskIntoConstraints = false
            return i
        }()
        
        addSubview(arrow)
        arrow.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
