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
            .rx_routingInformationAndLocations
            .subscribe(onNext: { [weak self] routingAndResponse in
                let (locations, response) = routingAndResponse
                let selectRouteCVC = SelectRouteCollectionViewController(locations: locations, routes: response.routes)
                selectRouteCVC.view.backgroundColor = self?.view.backgroundColor
                selectRouteCVC.title = "SELECT ROUTE"
                
                self?.hud?.dismiss(animated: true)
                self?.navigationController?.pushViewController(selectRouteCVC, animated: true)
            })
            .addDisposableTo(db)
    }
    
    override func bindTableView() {
        super.bindTableView()
        
        tableView
            .rx.itemSelected
            .asDriver()
            .map { [unowned self] indexPath in
                self.hud?.show(in: self.view)
                return self.locations.value[indexPath.row]
            }
            .drive(addLocationsViewModel.destinationLocation)
            .addDisposableTo(db)
    }
    
    override func bindBackBtn() {
        super.bindBackBtn()
        navigationItem.leftBarButtonItem?
            .rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.addLocationsViewModel.destinationLocation.value = nil
            })
            .addDisposableTo(db)
    }
}
