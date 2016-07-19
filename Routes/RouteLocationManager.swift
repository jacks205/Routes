//
//  RouteLocationManager.swift
//  Routes
//
//  Created by Mark Jackson on 7/17/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa
import GoogleMaps

let routesLocationManager = RoutesLocationManager()

class RoutesLocationManager {
    
    private (set) var rx_authorized: Driver<Bool>
    private (set) var rx_location: Driver<CLLocationCoordinate2D>
    private (set) var rx_bounds = Variable<GMSCoordinateBounds?>(nil)
    
    private let locationManager = CLLocationManager()
    
    let db = DisposeBag()
    
    init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        rx_authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx_didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.NotDetermined)
            .map {
                switch $0 {
                case .AuthorizedWhenInUse:
                    return true
                default:
                    return false
                }
        }
        
        rx_location = locationManager
            .rx_didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        rx_location
            .map { location in
                //http://stackoverflow.com/a/31127466/4684652
                func locationWithBearing(bearing: Double, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
                    let distRadians = distanceMeters / (6372797.6)
                    
                    let rbearing = bearing * M_PI / 180.0
                    
                    let lat1 = origin.latitude * M_PI / 180
                    let lon1 = origin.longitude * M_PI / 180
                    
                    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
                    let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
                    
                    return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
                }
                let northEast = locationWithBearing(45, distanceMeters: 50000, origin: location)
                let southWest = locationWithBearing(225, distanceMeters: 50000, origin: location)
                return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            }
            .drive(rx_bounds)
            .addDisposableTo(db)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}
