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
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum HERERouteAPI {
    case CalculateRoute((CLLocationCoordinate2D, CLLocationCoordinate2D), (CLLocationCoordinate2D, CLLocationCoordinate2D))
    case GetRoute(String)
}

extension HERERouteAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string: "https://route.cit.api.here.com/routing/7.2")! }
    public var path: String {
        switch self {
        case .CalculateRoute:
            return "/calculateroute.json"
        case .GetRoute:
            return "/getroute.json"
        }
    }
    public var method: Moya.Method {
        return .GET
    }
    public var parameters: [String: AnyObject]? {
        guard let apiId = HERE_API_APP_ID, let apiCode = HERE_API_APP_CODE else {
            fatalError("HERE API ID and CODE must be provided.")
        }
        var defaultParameters: [String: AnyObject] = [
            "app_id": apiId,
            "app_code": apiCode,
            "mode": "fastest;car;traffic:enabled",
            "alternatives": 2,
            "metricSystem": "imperial",
            "routeAttributes": "waypoints,summary,legs,lines,routeId"
        ]
        switch self {
        case .CalculateRoute(let waypoint0, let waypoint1):
            defaultParameters["waypoint0"] = "geo!\(waypoint0.0),\(waypoint0.1)"
            defaultParameters["waypoint1"] = "geo!\(waypoint1.0),\(waypoint1.1)"
        case .GetRoute(let routeId):
            defaultParameters["routeId"] = routeId
        }
        return defaultParameters
    }
    
    public var sampleData: NSData {
        return NSData()
    }
    
    public var multipartBody: [MultipartFormData]? {
        return nil
    }
}

private func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}
