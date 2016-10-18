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
    
    let rx_originLocation = Variable<RoutesLocation>(RoutesLocation())
    
    override func bindTableView() {
        super.bindTableView()
        //TODO: Rewrite to use HERE API and load in maps
    }
    
//    fileprivate func getSelectRouteViewController() -> SelectRouteCollectionViewController {
//        let selectRouteCVC = SelectRouteCollectionViewController()
//        selectRouteCVC.view.backgroundColor = self.view.backgroundColor
//        selectRouteCVC.title = "SELECT ROUTE"
//        return selectRouteCVC
//    }
}
