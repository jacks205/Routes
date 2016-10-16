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
        let addLocationVC = AddDestinationLocationViewController()
        let rx_originSelected = tableView
            .rx.itemSelected
            .map { $0.row }
            .filter { $0 > -1 }
            .asDriver(onErrorJustReturn: -1)
        
        rx_originSelected
            .map { self.locations.value[$0] }
            .drive(addLocationVC.rx_originLocation)
            .addDisposableTo(db)
        
        rx_originSelected
            .asObservable()
            .subscribe(onNext: { row in
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Starting Location"
                self.navigationController?.pushViewController(addLocationVC, animated: true)
            })
            .addDisposableTo(db)
    }
    
    override func bindBackBtn() {
        
    }

}
