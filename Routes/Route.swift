//
//  Route.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import CoreLocation

class IdentifiableObject: Object {
    private(set) dynamic var uuid = NSUUID().uuidString
}

enum GoogleDirectionsStatus: String {
    case ok = "OK", notFound = "NOT_FOUND", zeroResults = "ZERO_RESULTS", maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED", invalidRequest = "INVALID_REQUEST", overQueryLimit = "OVER_QUERY_LIMIT", requestDenied = "REQUEST_DENIED", unknownError = "UNKNOWN_ERROR"
}

enum GoogleTravelMode: String {
    case driving = "DRIVING", bicycling = "BICYCLING", walking = "WALKING"
}

enum GoogleManeuverType: String {
    case merge = "merge", turnRight = "turn-right", turnLeft = "turn-left", rampRight = "ramp-right", rampLeft = "ramp-left"
}

class GoogleDirectionsAPIResponse: Mappable {
    var status: GoogleDirectionsStatus!
    var error: String?
    var geocodedWaypoints: [GeocodedWaypoint]!
    var routes: [Route]!
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        error <- map["error_message"]
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes <- map["routes"]
        
        _ = routes.map {
            $0.startPlaceId = geocodedWaypoints.first?.placeID
            $0.endPlaceId = geocodedWaypoints.popLast()?.placeID
        }
    }
}

class GeocodedWaypoint: Mappable {
    var status: GoogleDirectionsStatus!
    var partialMatch: Bool!
    var placeID: String!
    var types: [String]!
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["geocoder_status"]
        partialMatch <- map["partial_match"]
        placeID <- map["place_id"]
        types <- map["types"]
    }
}

class Bounds: IdentifiableObject {
    dynamic var northEast: RouteLocationCoordinate2D!
    dynamic var southEast: RouteLocationCoordinate2D!
}

class Route: IdentifiableObject, Mappable {
    dynamic var startPlaceId: String?
    dynamic var endPlaceId: String?
    dynamic var bounds: Bounds? = Bounds()
    dynamic var copyrights: String!
    var legs = List<Leg>()
    dynamic var overviewPolyline: String!
    dynamic var summary: String!
    let warnings = List<RString>()
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        bounds!.northEast <- map["bounds.northeast"]
        bounds!.southEast <- map["bounds.southwest"]
        copyrights <- map["copyrights"]
        legs <- (map["legs"], ListTransform<Leg>())
        overviewPolyline <- map["overview_polyline.points"]
        summary <- map["summary"]
        
        var warningArr: [String]? = nil
        warningArr <- map["warnings"] // Maps to local variable
        let _ = warningArr?.map { warning in // Then fill options to `List`
            let value = RString()
            value.value = warning
            self.warnings.append(value)
        }
    }
}

class Leg: IdentifiableObject, Mappable {
    dynamic var distance: Int = 0
    dynamic var distanceText: String!
    dynamic var duration: Int = 0
    dynamic var durationText: String!
    dynamic var durationTraffic: Int = 0
    dynamic var durationTrafficText: String!
    
    dynamic var startAddress: String!
    dynamic var endAddress: String!
    
    dynamic var startLocation: RouteLocationCoordinate2D?
    dynamic var endLocation: RouteLocationCoordinate2D?
    
    var steps = List<Step>()
    
    var routeColor: UIColor {
        let percentage = Double(duration) / Double(durationTraffic)
        var color = lightBlueColor
        if percentage < 0.75 && percentage > 0.55 {
            color = darkYellowColor
        } else if percentage <= 0.55 {
            color = darkRedColor
        }
        return color
    }
    
    var routeColorText: UIColor {
        let percentage = Double(duration) / Double(durationTraffic)
        var color = lightBlueColorText
        if percentage < 0.75 && percentage > 0.55 {
            color = darkYellowColor
        } else if percentage <= 0.55 {
            color = darkRedColor
        }
        return color
    }
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        distance <- map["distance.value"]
        distanceText <- map["distance.text"]
        duration <- map["duration.value"]
        durationText <- map["duration.text"]
        durationTraffic <- map["duration_in_traffic.value"]
        durationTrafficText <- map["duration_in_traffic.text"]
        
        startAddress <- map["start_address"]
        endAddress <- map["end_address"]
        
        startLocation <- map["start_location"]
        endLocation <- map["end_location"]
        
        steps <- (map["steps"], ListTransform<Step>())
    }
}

class Step: IdentifiableObject, Mappable {
    dynamic var distance: Int = 0
    dynamic var distanceText: String!
    dynamic var duration: Int = 0
    dynamic var durationText: String!
    
    dynamic var startLocation: RouteLocationCoordinate2D?
    dynamic var endLocation: RouteLocationCoordinate2D?
    
    dynamic var instructions: String!
    dynamic var polyline: String!
    
    var travelMode: GoogleTravelMode {
        return GoogleTravelMode(rawValue: _travelMode)!
    }
    private dynamic var _travelMode: String!
    
    var maneuver: GoogleManeuverType? {
        return GoogleManeuverType(rawValue: _maneuver ?? "")
    }
    private dynamic var _maneuver: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        distance <- map["distance.value"]
        distanceText <- map["distance.text"]
        duration <- map["duration.value"]
        durationText <- map["duration.text"]
        
        startLocation <- map["start_location"]
        endLocation <- map["end_location"]
        
        instructions <- map["html_instructions"]
        polyline <- map["polyline.points"]
        
        _travelMode <- map["travel_mode"]
        _maneuver <- map["maneuver"]
    }
}

class RouteLocationCoordinate2D: IdentifiableObject, Mappable {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
    }
}

class RString: IdentifiableObject {
    dynamic var value: String?
}
