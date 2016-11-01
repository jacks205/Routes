//
//  RouteRanker.swift
//  Routes
//
//  Created by Mark Jackson on 11/1/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift

class RouteRanker {
    
    let baseRoute: Route
    
    init(base: Route) {
        self.baseRoute = base
    }
    
    func getHighestRankingRoute(routes: [Route]) -> Route? {
        let sorted = routes.sorted { self.score(base: baseRoute, new: $0) > self.score(base: baseRoute, new: $1) }
        return sorted.first
    }
    
    func score(base: Route, new: Route) -> RouteRankScore {
        let score = RouteRankScore()
        let zipped = zip([base], [new])
        _ = zipped.filter { $0.summary == $1.summary }.map { _ in score.increment(score: .summary) }
        _ = zipped.filter { $0.legs.first?.distance == $1.legs.first?.distance }.map { _ in score.increment(score: .overallDistance) }
        _ = zipped.filter { $0.legs.first?.steps.count == $1.legs.first?.steps.count }.map { _ in score.increment(score: .stepCount) }
        _ = zip(base.legs.first!.steps, new.legs.first!.steps).filter { $0.distance == $1.distance }.map { _ in score.increment(score: .stepDistance) }
        return score
    }
    
}

extension RouteRanker {
    func rx_getHighestRankingRoute(routes: [Route]?) -> Observable<Route> {
        return Observable<Route>.create { obs -> Disposable in
            if let routes = routes, let highestRoute = self.getHighestRankingRoute(routes: routes) {
                obs.onNext(highestRoute)
            } else {
               obs.onError(RouteRankerError.noMatchingRoute)
            }
            obs.onCompleted()
            return Disposables.create()
        }
    }
}

class RouteRankScore {
    var overallScore = 0
    
    func increment(score: RouteScore) {
        overallScore = overallScore + score
    }
}

enum RouteScore: Int {
    case stepDistance = 1
    case stepCount = 2
    case summary = 4
    case overallDistance = 6
}

//MARK: - Ranker ErrorTypes

enum RouteRankerError: Error {
    case noMatchingRoute
}

//MARK: - Operator Overloads

func +(left: Int, right: RouteScore) -> Int {
    return left + right.rawValue
}

func +(left: Int, right: RouteRankScore) -> Int {
    return left + right.overallScore
}

func >(left: RouteRankScore, right: RouteRankScore) -> Bool {
    return left.overallScore > right.overallScore
}

func <(left: RouteRankScore, right: RouteRankScore) -> Bool {
    return left.overallScore < right.overallScore
}
