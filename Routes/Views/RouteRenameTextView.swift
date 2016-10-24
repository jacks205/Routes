//
//  RouteRenameTextView.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextContainerView: UIView, UITextViewDelegate {
    
    static let fontSize: CGFloat = 12
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: "Montserrat-Regular", size: fontSize)
        tv.textColor = .white
        tv.textContainer.maximumNumberOfLines = 2
        tv.textContainer.lineBreakMode = .byClipping
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.tintColor = .white
        tv.backgroundColor = .clear
        tv.textContainer.lineFragmentPadding = 0
        tv.contentInset.bottom = -8
        tv.textAlignment = .left
        return tv
    }()
    
//    private let lineLayer: CAShapeLayer = {
//        let l = CAShapeLayer()
//        l.lineWidth = 1
//        l.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
//        return l
//    }()
    
    private let btn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    var rx_tap: Observable<String> {
        return btn
            .rx
            .tap
            .map { return self.textView.text }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        textView.layer.addSublayer(lineLayer)
        addSubview(textView)
        addSubview(btn)
        setConstraints()
        textView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        let iv: UIImageView = {
            let iv = UIImageView(image: #imageLiteral(resourceName: "edit-pencil"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        addSubview(iv)
        iv.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 3).isActive = true
        iv.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: 0).isActive = true
        
        textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        let vL = textView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8)
        vL.priority = 750
        vL.isActive = true
        let vT = textView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8)
        vT.priority = 750
        vT.isActive = true
        let v1 = textView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8)
        v1.priority = 750
        v1.isActive = true
        let v2 = textView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        v2.priority = 750
        v2.isActive = true
        
        btn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        btn.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        btn.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        textView.contentSize = textView.frame.size
        
//        lineLayer.frame = bounds
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: textView.frame.height))
//        path.addLine(to: CGPoint(x: textView.frame.width, y: textView.frame.height))
//        lineLayer.path = path.cgPath
    }
    
    func setTextView(text: String) {
        let attributedString = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: textView.font!,
            NSForegroundColorAttributeName: textView.textColor!,
            NSUnderlineStyleAttributeName: NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue),
            NSUnderlineColorAttributeName: UIColor.white.withAlphaComponent(0.5)
            ])
        textView.attributedText = attributedString
    }
    
    private func shrinkFontToFit(textView: UITextView) {
        var size: CGFloat = TextContainerView.fontSize
        let minSize: CGFloat = 5
        let testTV = UITextView()
        testTV.text = textView.text
        testTV.font = UIFont(name: "Montserrat-Regular", size: size)
        while size > minSize && testTV.sizeThatFits(textView.frame.size).height >= textView.frame.height {
            size = size - 0.2
            testTV.font = UIFont(name: "Montserrat-Regular", size: size)
        }
        textView.font = UIFont(name: "Montserrat-Regular", size: size)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        shrinkFontToFit(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + text.characters.count - range.length < 55
    }
}
