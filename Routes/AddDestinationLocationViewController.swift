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

class AddDestinationLocationViewController: AddLocationViewController {
    
    var originLocation: RoutesLocation?
    var destinationLocation: RoutesLocation?
    
    let hud = JGProgressHUD(style: .ExtraLight)
    
    override func bindTableView() {
        super.bindTableView()
        tableView
            .rx_itemSelected
            .flatMap { self.getPlaceIDs($0) }
            .flatMap { self.getDirections($0.0, destinationPlaceID: $0.1) }
            .subscribeNext { [weak self] response in
                self?.hud.dismiss()
                if let selectRouteCVC = self?.getSelectRouteViewController() {
                    selectRouteCVC.directionsResponse = response
                    selectRouteCVC.originLocation = self?.originLocation
                    selectRouteCVC.destinationLocation = self?.destinationLocation
                    self?.navigationController?.pushViewController(selectRouteCVC, animated: true)
                }
            }
            .addDisposableTo(db)
        
    }
    
    private func getPlaceIDs(index: NSIndexPath) -> Observable<(String, String)> {
        return Observable.create { obs -> Disposable in
            self.destinationLocation = self.locations.value[index.row]
            if  let destinationPlaceID = self.destinationLocation?.placeID,
                let originPlaceID = self.originLocation?.placeID {
                obs.onNext((originPlaceID, destinationPlaceID))
            }
            obs.onCompleted()
            return NopDisposable.instance
        }
    }
    
    private func getDirections(originPlaceID: String, destinationPlaceID: String) -> Observable<DirectionsResponse> {
        hud.showInView(view)
        return RoutesDirectionAPI
            .request(.DirectionsPlaceID(origin: originPlaceID, destination: destinationPlaceID))
            .mapObject(DirectionsResponse)
    }
    
    private func getSelectRouteViewController() -> SelectRouteCollectionViewController {
        let selectRouteCVC = SelectRouteCollectionViewController()
        selectRouteCVC.view.backgroundColor = self.view.backgroundColor
        selectRouteCVC.title = "SELECT ROUTE"
        return selectRouteCVC
    }
}
