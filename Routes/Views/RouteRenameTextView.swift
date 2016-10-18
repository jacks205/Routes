//
//  RouteRenameTextView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RouteRenameTextView: UIView, UITextViewDelegate {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: "Montserrat-Regular", size: 14)
        tv.textColor = .white
        tv.textContainer.maximumNumberOfLines = 2
        tv.textContainer.lineBreakMode = .byClipping
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.backgroundColor = .clear
        tv.tintColor = .white
        tv.contentInset = UIEdgeInsets.zero
        return tv
    }()
    
    private let lineLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        l.lineWidth = 1
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(lineLayer)
        addSubview(textView)
        textView.delegate = self
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        lineLayer.path = path.cgPath
    }
    
    func setConstraints() {
        addConstraintsWithFormat("H:|[v0]|", views: textView)
        addConstraintsWithFormat("V:|[v0]|", views: textView)
    }
    
    func setTextView(text: String) {
        textView.text = text
        textView.sizeToFit()
        textView.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var fontSize: CGFloat = 14
        let testTV = UITextView()
        testTV.text = textView.text
        testTV.font = UIFont(name: "Montserrat-Regular", size: fontSize)
        while testTV.sizeThatFits(textView.frame.size).height >= textView.frame.height {
            fontSize = fontSize - 0.2
            testTV.font = UIFont(name: "Montserrat-Regular", size: fontSize)
        }
        textView.font = testTV.font
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + text.characters.count - range.length < 55
    }

}
