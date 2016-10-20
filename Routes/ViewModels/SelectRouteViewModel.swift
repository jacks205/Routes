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
    
    init(routes: [RouteType]) {
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
