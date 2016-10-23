//
//  SelectRouteViewModel.swift
//  Routes
//
//  Created by Mark Jackson on 10/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift
import CocoaLumberjack
import MapKit
import Kanna

struct SelectRouteViewModel {
    let routes: Variable<[RouteType]>
    
    let rx_nicknamesValid: Observable<Bool>

    init(routes: [RouteType], originLocation: Observable<String>, destinationLocation: Observable<String>) {
        self.rx_nicknamesValid =
            Observable.combineLatest(originLocation, destinationLocation) { origin, destination -> Bool in
                return origin.characters.count > 0 && destination.characters.count > 0
            }
            .shareReplay(1)
        self.routes = Variable<[RouteType]>(routes)
        
    }
    
    var legs: [RouteLeg] {
        return routes
            .value
            .flatMap { $0.legs }
    }
    
    var maneuvers: [[RouteManeuver]] {
        return routes
            .value
            .flatMap { $0.legs }
            .flatMap { $0 }
            .map { $0.maneuver }
    }
    
    var rx_maneuvers: Observable<[[RouteManeuver]]> {
        return Observable.of(maneuvers)
    }
    
    var summary: [RouteSummary] {
        return routes.value.flatMap { $0.summary }
    }
    
    var rx_summary: Observable<[RouteSummary]> {
        return Observable.of(summary)
    }
}
