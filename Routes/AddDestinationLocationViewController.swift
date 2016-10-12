//
//  AddDestinationLocationViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya_ObjectMapper
import JGProgressHUD
import MapboxStatic

class AddDestinationLocationViewController: AddLocationViewController {
    
    var rx_originLocation = Variable<RoutesLocation>(RoutesLocation())
    var rx_destinationLocation = Variable<RoutesLocation>(RoutesLocation())
    
    let hud = JGProgressHUD(style: .ExtraLight)
    
    override func bindTableView() {
        super.bindTableView()
        let selectRouteVC = getSelectRouteViewController()
        //TODO: Rewrite to use HERE API and load in maps
        let rx_destinationSelected = tableView
            .rx_itemSelected
            .map { $0.row }
            .filter { $0 > -1 }
            .asDriver(onErrorJustReturn: -1)
        
        rx_destinationSelected
            .map { self.locations.value[$0] }
            .drive(rx_destinationLocation)
            .addDisposableTo(db)
        
    
    }
    
    private func rx_getPlaceIDs(row: Int) -> Observable<(String, String)> {
        return Observable.create { obs -> Disposable in
            self.rx_destinationLocation.value = self.locations.value[row]
            if  let destinationPlaceID = self.rx_destinationLocation.value.placeID,
                let originPlaceID = self.rx_originLocation.value.placeID {
                obs.onNext((originPlaceID, destinationPlaceID))
            }
            obs.onCompleted()
            return NopDisposable.instance
        }
    }
    
    
    private func getSelectRouteViewController() -> SelectRouteCollectionViewController {
        let selectRouteCVC = SelectRouteCollectionViewController()
        selectRouteCVC.view.backgroundColor = self.view.backgroundColor
        selectRouteCVC.title = "SELECT ROUTE"
        return selectRouteCVC
    }
}
