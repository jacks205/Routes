//
//  RoutesDirectionsAPI.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import RxSwift
import GoogleMaps
import Moya

// MARK: - Provider setup
var GoogleDirectionsAPIKey: String?

#if DEBUG
    let RoutesDirectionAPI: RxMoyaProvider<GoogleDirectionsAPI> = RxMoyaProvider<GoogleDirectionsAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
#else
    let RoutesDirectionAPI: RxMoyaProvider<GoogleDirectionsAPI> = RxMoyaProvider<GoogleDirectionsAPI>()
#endif

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum GoogleDirectionsAPI {
    case DirectionsPlaceID(origin: String, destination: String)
}

extension GoogleDirectionsAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string: "https://maps.googleapis.com/maps/api")! }
    public var path: String {
        switch self {
        case .DirectionsPlaceID:
            return "/directions/json"
        }
    }
    public var method: Moya.Method {
        return .GET
    }
    public var parameters: [String: AnyObject]? {
        guard let apiKey = GoogleDirectionsAPIKey else {
            fatalError("Google Directions APIKey must be provided.")
        }
        var defaultParameters: [String: AnyObject] = [
            "alternatives": "true",
            "departure_time": "now",
            "traffic_model": "best_guess",
            "avoid": "ferries",
            "key": apiKey]
        switch self {
        case .DirectionsPlaceID(let origin, let destination):
            defaultParameters["origin"] = "place_id:\(origin)"
            defaultParameters["destination"] = "place_id:\(destination)"
        }
        return defaultParameters
    }
    
    public var sampleData: NSData {
        return NSData()
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
