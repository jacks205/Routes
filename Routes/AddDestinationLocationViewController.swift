//
//  AddDestinationLocationViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa

class AddDestinationLocationViewController: AddLocationViewController {
    
    override func loadView() {
        super.loadView()
        bindBackBtn()
    }
    
    override func bindNextBtn() {
        super.bindNextBtn()
        nextBtn
            .rx_tap
            .subscribeNext {
                let selectedValue = self.tableView.indexPathForSelectedRow
                DDLogInfo("Destination!")
            }
            .addDisposableTo(db)
    }
    
    func bindBackBtn() {
        let backBtn = UIBarButtonItem()
        backBtn.image = UIImage(named: "back")
        backBtn.tintColor = UIColor.whiteColor()
        backBtn
            .rx_tap
            .subscribeNext { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
            }
            .addDisposableTo(db)
        navigationItem.leftBarButtonItem = backBtn
    }

}
