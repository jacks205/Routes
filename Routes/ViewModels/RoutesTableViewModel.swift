//
//  RoutesTableViewModel.swift
//  Routes
//
//  Created by Mark Jackson on 10/31/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift

class RoutesTableViewModel {
    
    let routes = Variable<[Route]>([])
    
    let dataService: RoutesDataService
    
    let db = DisposeBag()
    
    init(dataService: RoutesDataService = RoutesDataService.instance) {
        self.dataService = dataService
        retrieveRoutesFromDataService()
    }
    
    //MARK: - Local Storage Functions
    
    func retrieveRoutesFromDataService() {
        dataService
            .rx_loadRoutes()
            .bindTo(routes)
            .addDisposableTo(db)
    }
    
    //MARK: - Routes Data Functions
    func rx_refreshRoutes() -> Observable<[Route]> {
        return rx_refreshRoutes(routes: routes.value)
    }
    
    func rx_refreshRoutes(routes: [Route]) -> Observable<[Route]> {
        return routes
                .filter { $0.startPlaceId != nil && $0.endPlaceId != nil }
                .flatMap { route -> Observable<Route> in
                    let t = GoogleDirectionAPI
                        .request(.directions(route.startPlaceId!, route.endPlaceId!))
                        .mapObject(GoogleDirectionsAPIResponse.self)
                        .map { $0.routes }
                        .flatMap { newRoutes -> Observable<Route> in
                            let ranker = RouteRanker(base: route)
                            return ranker.rx_getHighestRankingRoute(routes: newRoutes)
                        }
                        .map { highestRanking -> Route in
                            do {
                                try self.dataService.updateRoute(route: route, newRoute: highestRanking)
                            } catch {
                                //TODO: error handling
                            }
                            return route
                        }
                    return t
                }.toObservable().merge()
                .toArray()
    }
    
    func configureCell(route: Route, cell: RouteTableViewCell) {
        if let duration = route.legs.first?.duration,
            let durationTraffic = route.legs.first?.durationTraffic {
            let percentage = Double(durationTraffic) / Double(duration)
            var color = darkGreenColor
            if percentage >= 0.75 {
                color = darkRedColor
            } else if percentage < 0.75 && percentage > 0.45 {
                color = darkYellowColor
            }
            cell.updateProgressBarView(percentage, color: color, text: "\(percentage)")
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.originNameLabel.text = route.legs.first?.startAddress
        cell.destinationNameLabel.text = route.legs.first?.endAddress
        cell.descriptionLabel.text = route.summary
        cell.distanceLabel.text = route.legs.first?.distanceText
        cell.progressBarView.textLabel.font = UIFont(name: "OpenSans", size: 10)
        cell.progressBarView.textLabel.textColor = UIColor.white
        
    }
}
