//
//  AddDestinationLocationViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import Moya_ObjectMapper
import JGProgressHUD

class AddDestinationLocationViewController: AddLocationViewController {
    
    let hud = JGProgressHUD(style: .extraLight)
    
    let addLocationsViewModel: AddLocationsViewModel
    
    init(viewModel: AddLocationsViewModel) {
        addLocationsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationsViewModel
            .rx_retrieveRoutingInformation()
            .subscribe(onNext: { [unowned self] response in
                let selectRouteCVC = SelectRouteCollectionViewController(routes: response.routes)
                selectRouteCVC.view.backgroundColor = self.view.backgroundColor
                selectRouteCVC.title = "SELECT ROUTE"
                self.navigationController?.pushViewController(selectRouteCVC, animated: true)
            })
            .addDisposableTo(db)
    }
    
    override func bindTableView() {
        super.bindTableView()
        
        tableView
            .rx.itemSelected
            .asDriver()
            .map { self.locations.value[$0.row] }
            .drive(addLocationsViewModel.destinationLocation)
            .addDisposableTo(db)
    }
}
