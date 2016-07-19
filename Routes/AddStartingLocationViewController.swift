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
    
    override func bindTableView() {
        super.bindTableView()
        tableView
            .rx_itemSelected
            .subscribeNext { index in
                let location = self.locations.value[index.row]
                let addLocationVC = AddDestinationLocationViewController()
                addLocationVC.originLocation = location
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Destination"
                self.navigationController?.pushViewController(addLocationVC, animated: true)
            }
            .addDisposableTo(db)
        
    }
    
    override func bindBackBtn() {
        
    }

}
