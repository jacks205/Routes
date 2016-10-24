//
//  AddLocationsViewModel.swift
//  Routes
//
//  Created by Mark Jackson on 10/22/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//
import RxSwift
import GooglePlaces

typealias CLLocationCoordinates = (origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D)
typealias RoutesLocations = (origin: RoutesLocation, destination: RoutesLocation)

class AddLocationsViewModel {
    
    let originLocation = Variable<RoutesLocation?>(nil)
    let destinationLocation = Variable<RoutesLocation?>(nil)
    
    let rx_locationsSelected: Observable<Bool>
    var rx_locations: Observable<RoutesLocations> {
        return rx_locationsSelected
            .filter { $0 }
            .map { _ in return (self.originLocation.value!, self.destinationLocation.value!) }
            .shareReplay(1)
    }
    
    var rx_routingInformation: Observable<GoogleDirectionsAPIResponse> {
        return rx_locations
            .filter { $0.origin.placeID != nil && $0.destination.placeID != nil }
            .flatMap { locations in
                return GoogleDirectionAPI
                    .request(.directions(locations.origin.placeID!, locations.destination.placeID!))
                    .mapObject(GoogleDirectionsAPIResponse.self)
        }
    }
    
    var rx_routingInformationAndLocations: Observable<(RoutesLocations, GoogleDirectionsAPIResponse)> {
        return Observable.combineLatest(rx_locations, rx_routingInformation, resultSelector: { (locations, response) -> (RoutesLocations, GoogleDirectionsAPIResponse) in
            return (locations, response)
        })
    }
    
    init() {
        rx_locationsSelected = Observable.combineLatest(originLocation.asObservable(), destinationLocation.asObservable()) { r1, r2 -> Bool in
            return r1 != nil && r2 != nil
        }
        .shareReplay(1)
    }
    
    
}
