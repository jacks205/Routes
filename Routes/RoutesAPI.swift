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
var GMS_SERVICES_API_KEY: String?

let endpointClosure = { (target: GoogleDirectionsAPI) -> Endpoint<GoogleDirectionsAPI> in
    return Endpoint<GoogleDirectionsAPI>(URL: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: URLEncoding.default, httpHeaderFields: nil)
}
#if DEBUG
let GoogleDirectionAPI: RxMoyaProvider<GoogleDirectionsAPI> = RxMoyaProvider<GoogleDirectionsAPI>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
#else
    let GoogleDirectionAPI: RxMoyaProvider<GoogleDirectionsAPI> = RxMoyaProvider<GoogleDirectionsAPI>(endpointClosure: endpointClosure)
#endif

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

public enum GoogleDirectionsAPI {
    case directions(String, String)
}

extension GoogleDirectionsAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://maps.googleapis.com/maps/api")! }
    public var path: String {
        switch self {
        case .directions:
            return "/directions/json"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        guard let apiKey = GMS_SERVICES_API_KEY else {
            fatalError("GMS API KEY must be provided.")
        }
        var defaultParameters: [String: Any] = [
            "key": apiKey as AnyObject,
            "traffic_model": "best_guess" as AnyObject,
            "alternatives": "true" as AnyObject,
            "departure_time": "now" as AnyObject
        ]
        switch self {
        case .directions(let pid1, let pid2):
            defaultParameters["origin"] = "place_id:\(pid1)" as AnyObject?
            defaultParameters["destination"] = "place_id:\(pid2)" as AnyObject?
        return defaultParameters
        }
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

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
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
