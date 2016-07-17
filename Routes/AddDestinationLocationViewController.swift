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
    
    override func bindNextBtn() {
        super.bindNextBtn()
        nextBtn
            .rx_tap
            .subscribeNext {
                let selectedValue = self.tableView.indexPathForSelectedRow
                let selectRouteCVC = SelectRouteCollectionViewController()
                selectRouteCVC.view.backgroundColor = self.view.backgroundColor
                selectRouteCVC.title = "CHOOSE ROUTE"
                self.navigationController?.pushViewController(selectRouteCVC, animated: true)
            }
            .addDisposableTo(db)
    }
    
}
