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
    
    let addLocationsViewModel: AddLocationsViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        addLocationsViewModel = AddLocationsViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationsViewModel.originLocation
            .asDriver()
            .drive(onNext: { _ in
                let addLocationVC = AddDestinationLocationViewController(viewModel: self.addLocationsViewModel)
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Destination"
                self.navigationController?.pushViewController(addLocationVC, animated: true)
            })
            .addDisposableTo(db)
    }
    
    override func bindTableView() {
        super.bindTableView()
        tableView
            .rx.itemSelected
            .asDriver()
            .map { self.locations.value[$0.row] }
            .drive(addLocationsViewModel.originLocation)
            .addDisposableTo(db)
    }
    
    override func bindBackBtn() {
        
    }

}
