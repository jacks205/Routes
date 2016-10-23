//
//  AddNicknameSectionView.swift
//  Routes
//
//  Created by Mark Jackson on 10/20/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNicknameSectionView: UIView, UITextFieldDelegate {
    
    let btn: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        b.adjustsImageWhenHighlighted = true
        b.tintColor = .white
        return b
    }()
    
    let textField: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = UIFont.montserratRegular(size: 14)
        t.adjustsFontSizeToFitWidth = true
        t.attributedPlaceholder = NSAttributedString(string: "Enter New Nickname", attributes: [NSFontAttributeName: UIFont.montserratRegular(size: 14)!, NSForegroundColorAttributeName: UIColor.white])
        t.textColor = .white
        t.tintColor = .white
        t.autocorrectionType = .no
        return t
    }()
    
    var rx_add: Driver<String> {
        return btn.rx.tap
            .asDriver()
            .map { _ in return self.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(btn)
        addSubview(textField)
        setConstraints()
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        addConstraintsWithFormat("H:|-16-[v0]-10-[v1]-16-|", views: textField, btn)
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 45
    }
}
