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
import GooglePlaces

class RoutesLocationService {
    
    static let instance = RoutesLocationService()
    
    fileprivate (set) var authorized: Driver<Bool>
    fileprivate (set) var location: Driver<CLLocationCoordinate2D>
    fileprivate (set) var bounds = Variable<GMSCoordinateBounds?>(nil)
    
    fileprivate let locationManager = CLLocationManager()
    
    let db = DisposeBag()
    
    init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx_didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return true
                default:
                    return false
                }
        }
        
        location = locationManager
            .rx_didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        location
            .map { location in
                //http://stackoverflow.com/a/31127466/4684652
                func locationWithBearing(_ bearing: Double, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
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
            .drive(bounds)
            .addDisposableTo(db)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

class RxCLLocationManagerDelegateProxy: DelegateProxy, CLLocationManagerDelegate, DelegateProxyType {
    //We need a way to read the current delegate
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        //swiftlint:disable force_cast
        let lm: CLLocationManager = object as! CLLocationManager
        return lm.delegate
    }
    //We need a way to set the current delegate
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        //swiftlint:disable force_cast
        let lm: CLLocationManager = object as! CLLocationManager
        lm.delegate = delegate as? CLLocationManagerDelegate
    }
}

extension CLLocationManager {
    
    public var rx_delegate: DelegateProxy {
        return RxCLLocationManagerDelegateProxy.proxyForObject(RxCLLocationManagerDelegateProxy.self)
    }
    
    public var rx_didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return rx_delegate.observe(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { params in
                //swiftlint:disable force_cast
                return params[1] as! CLAuthorizationStatus
        }
    }
    
    public var rx_didUpdateLocations: Observable<[CLLocation]> {
        return rx_delegate.observe(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { params in
                //swiftlint:disable force_cast
                return params[1] as! [CLLocation]
        }
    }
    
}
