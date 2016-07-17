//
//  AddStartingLocationViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa

class AddStartingLocationViewController: AddLocationViewController {
    
    override func bindNextBtn() {
        super.bindNextBtn()
        nextBtn
            .rx_tap
            .subscribeNext {
                let selectedValue = self.tableView.indexPathForSelectedRow
                let addLocationVC = AddDestinationLocationViewController()
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Destination"
                self.navigationController?.pushViewController(addLocationVC, animated: true)
            }
            .addDisposableTo(db)
    }

}
