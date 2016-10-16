//
//  RoutesAPI.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift
import Moya
import CoreLocation

// MARK: - Provider setup
var HERE_API_APP_ID: String?
var HERE_API_APP_CODE: String?

#if DEBUG
    let RoutesDirectionAPI: RxMoyaProvider<HERERouteAPI> = RxMoyaProvider<HERERouteAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
#else
    let RoutesDirectionAPI: RxMoyaProvider<HERERouteAPI> = RxMoyaProvider<HERERouteAPI>()
#endif

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

public enum HERERouteAPI {
    case calculateRoute((CLLocationCoordinate2D, CLLocationCoordinate2D), (CLLocationCoordinate2D, CLLocationCoordinate2D))
    case getRoute(String)
}

extension HERERouteAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://route.cit.api.here.com/routing/7.2")! }
    public var path: String {
        switch self {
        case .calculateRoute:
            return "/calculateroute.json"
        case .getRoute:
            return "/getroute.json"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        guard let apiId = HERE_API_APP_ID, let apiCode = HERE_API_APP_CODE else {
            fatalError("HERE API ID and CODE must be provided.")
        }
        var defaultParameters: [String: Any] = [
            "app_id": apiId as AnyObject,
            "app_code": apiCode as AnyObject,
            "mode": "fastest;car;traffic:enabled" as AnyObject,
            "alternatives": 2 as AnyObject,
            "metricSystem": "imperial" as AnyObject,
            "routeAttributes": "waypoints,summary,legs,lines,routeId" as AnyObject
        ]
        switch self {
        case .calculateRoute(let waypoint0, let waypoint1):
            defaultParameters["waypoint0"] = "geo!\(waypoint0.0),\(waypoint0.1)" as AnyObject?
            defaultParameters["waypoint1"] = "geo!\(waypoint1.0),\(waypoint1.1)" as AnyObject?
        case .getRoute(let routeId):
            defaultParameters["routeId"] = routeId as AnyObject?
        }
        return defaultParameters
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    public var task: Task {
        return Task.request
    }
    
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}
