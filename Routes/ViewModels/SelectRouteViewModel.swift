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
    
    func rx_polyline(maneuvers: [RouteManeuver]) -> Observable<MKPolyline> {
        return Observable<MKPolyline>.create { obs -> Disposable in
//            DispatchQueue.global(qos: .userInitiated).async {
                let coordinates: [CLLocationCoordinate2D] = maneuvers
                    .map {
                        $0.position
                    }
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//                DispatchQueue.main.async {
                    obs.onNext(polyline)
//                }
//            }
            return Disposables.create()
        }
    }
}
