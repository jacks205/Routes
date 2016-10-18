//
//  RoutesKeyboardToolbar.swift
//  Routes
//
//  Created by Mark Jackson on 10/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit

class RoutesKeyboardToolbar: UIToolbar {
    
    let doneBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "DONE", style: .plain, target: nil, action: nil)
        btn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Mont", size: <#T##CGFloat#>)], for: <#T##UIControlState#>)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneBtn], animated: false)
    }

}
