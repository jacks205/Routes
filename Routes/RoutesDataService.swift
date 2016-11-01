//
//  RoutesDataService.swift
//  Routes
//
//  Created by Mark Jackson on 10/31/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift
import RealmSwift
import CocoaLumberjack

class RoutesDataService {
    
    static let instance = RoutesDataService()
    
    let realm: Realm
    
    init(config: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        do {
            realm = try Realm(configuration: config)
        } catch {
            fatalError("Error initializing Realm")
        }
    }
    
    func saveRoutes(routes: [Route]) throws {
        try realm.write {
            realm.add(routes)
        }
    }
    
    func loadRoutes() -> [Route] {
        let routes = realm.objects(Route.self)
        return Array(routes)
    }
    
    func updateRoute(route: Route, newRoute: Route) throws {
        try realm.write {
            route.update(newRoute: newRoute)
        }
    }
    
}

extension RoutesDataService {
    func rx_saveRoutes(routes: [Route]) -> Observable<Void> {
        return Observable<Void>.create { obs -> Disposable in
            do {
                try self.saveRoutes(routes: routes)
                obs.onNext()
            } catch {
                obs.onError(RoutesDataServiceError.unableToSave)
            }
            obs.onCompleted()
            return Disposables.create()
        }
    }
    
    func rx_loadRoutes() -> Observable<[Route]> {
        return Observable<[Route]>.create { obs -> Disposable in
            let routes = self.loadRoutes()
            obs.onNext(routes)
            obs.onCompleted()
            return Disposables.create()
        }
    }
}

enum RoutesDataServiceError: Error {
    case unableToSave
}
