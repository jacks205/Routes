//
//  AddRouteBaseViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa

class AddRouteBaseViewController: UIViewController {
    
    let db = DisposeBag()
    
    override func loadView() {
        super.loadView()
        bindBackBtn()
        bindCloseBtn()
    }
    
    func bindCloseBtn() {
        let closeBtn = UIBarButtonItem()
        closeBtn.image = UIImage(named: "cancel")
        closeBtn.tintColor = UIColor.white
        closeBtn
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(db)
        navigationItem.rightBarButtonItem = closeBtn
    }
    
    func bindBackBtn() {
        let backBtn = UIBarButtonItem()
        backBtn.image = UIImage(named: "back")
        backBtn.tintColor = UIColor.white
        backBtn
            .rx.tap
            .subscribe(onNext: { [weak self] in
                let _ = self?.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(db)
        navigationItem.leftBarButtonItem = backBtn
    }
}
