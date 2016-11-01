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
    let routes: Variable<[Route]>
    let locations: Variable<RoutesLocations>
    
    let rx_nicknamesValid: Observable<Bool>

    init(locations: RoutesLocations, routes: [Route], originLocation: Observable<String>, destinationLocation: Observable<String>) {
        self.rx_nicknamesValid =
            Observable.combineLatest(originLocation, destinationLocation) { origin, destination -> Bool in
                return origin.characters.count > 0 && destination.characters.count > 0
            }
            .shareReplay(1)
        self.routes = Variable<[Route]>(routes)
        self.locations = Variable<RoutesLocations>(locations)
    }
    
    var legs: [Leg] {
        return routes
            .value
            .flatMap { Array($0.legs) }
    }
    
    var steps: [[Step]] {
        return routes
            .value
            .flatMap { route -> [Leg] in
                return Array(route.legs)
            }
            .flatMap { $0 }
            .map { leg -> [Step] in
                return Array(leg.steps)
            }
    }
    
    func routeColor(index: Int) -> UIColor? {
        return routes.value[index].legs.first?.routeColor
    }
}
