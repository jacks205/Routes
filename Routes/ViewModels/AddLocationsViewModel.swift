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
    
    init() {
        rx_locationsSelected = Observable.combineLatest(originLocation.asObservable(), destinationLocation.asObservable()) { r1, r2 -> Bool in
            return r1 != nil && r2 != nil
        }
        .shareReplay(1)
    }
    
    func rx_retrieveRoutingInformation() -> Observable<HERERouteDirectionsAPIResponse> {
        return rx_locations
            .filter { $0.origin.placeID != nil && $0.destination.placeID != nil }
            .flatMap({ (locations) -> Observable<CLLocationCoordinates> in
                return rx_coordinatesFromPlaceIDs(locations.origin.placeID!, locations.destination.placeID!)
            })
            .flatMap { locations in
                return RoutesDirectionAPI
                    .request(.calculateRoute(locations.origin, locations.destination))
                    .mapObject(HERERouteDirectionsAPIResponse.self)
            }
    }
}

func rx_coordinatesFromPlaceIDs(_ p1: String, _ p2: String) -> Observable<CLLocationCoordinates> {
    return Observable.combineLatest(GMSPlacesClient.shared().rx_coordinatesFromPlaceID(placeID: p1), GMSPlacesClient.shared().rx_coordinatesFromPlaceID(placeID: p2), resultSelector: { (c1, c2) -> CLLocationCoordinates in
        return (c1, c2)
    })
}
