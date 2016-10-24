//
//  Route.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import ObjectMapper
import CoreLocation

enum GoogleDirectionsStatus: String {
    case ok = "OK", notFound = "NOT_FOUND", zeroResults = "ZERO_RESULTS", maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED", invalidRequest = "INVALID_REQUEST", overQueryLimit = "OVER_QUERY_LIMIT", requestDenied = "REQUEST_DENIED", unknownError = "UNKNOWN_ERROR"
}

enum GoogleTravelMode: String {
    case driving = "DRIVING", bicycling = "BICYCLING", walking = "WALKING"
}

enum GoogleManeuverType: String {
    case merge = "merge", turnRight = "turn-right", turnLeft = "turn-left", rampRight = "ramp-right", rampLeft = "ramp-left"
}

struct GoogleDirectionsAPIResponse: Mappable {
    var status: GoogleDirectionsStatus!
    var error: String?
    var geocodedWaypoints: [GeocodedWaypoint]!
    var routes: [Route]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        error <- map["error_message"]
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes <- map["routes"]
    }
}

struct GeocodedWaypoint: Mappable {
    var status: GoogleDirectionsStatus!
    var partialMatch: Bool!
    var placeID: String!
    var types: [String]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        status <- map["geocoder_status"]
        partialMatch <- map["partial_match"]
        placeID <- map["place_id"]
        types <- map["types"]
    }
}

struct Route: Mappable {
    struct Bounds {
        var northEast: CLLocationCoordinate2D!
        var southEast: CLLocationCoordinate2D!
    }
    
    var bounds: Bounds!
    var copyright: String!
    var legs: [Leg]!
    var overviewPolyline: String!
    var summary: String!
    var warnings: [String]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        bounds = Bounds()
        bounds.northEast <- map["bounds.northeast"]
        bounds.southEast <- map["bounds.southwest"]
        copyright <- map["copyright"]
        legs <- map["legs"]
        overviewPolyline <- map["overview_polyline.points"]
        summary <- map["summary"]
        warnings <- map["warnings"]
    }
}

struct Leg: Mappable {
    var distance: Int!
    var distanceText: String!
    var duration: Int!
    var durationText: String!
    var durationTraffic: Int!
    var durationTrafficText: String!
    
    var startAddress: String!
    var endAddress: String!
    
    var startLocation: CLLocationCoordinate2D!
    var endLocation: CLLocationCoordinate2D!
    
    var steps: [Step]!
    
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
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
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
        
        steps <- map["steps"]
    }
}

struct Step: Mappable {
    var distance: Int!
    var distanceText: String!
    var duration: Int!
    var durationText: String!
    
    var startLocation: CLLocationCoordinate2D!
    var endLocation: CLLocationCoordinate2D!
    
    var instructions: String!
    var polyline: String!
    
    var travelMode: GoogleTravelMode!
    
    var maneuver: GoogleManeuverType?
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        distance <- map["distance.value"]
        distanceText <- map["distance.text"]
        duration <- map["duration.value"]
        durationText <- map["duration.text"]
        
        startLocation <- map["start_location"]
        endLocation <- map["end_location"]
        
        instructions <- map["html_instructions"]
        polyline <- map["polyline.points"]
        
        travelMode <- map["travel_mode"]
        maneuver <- map["maneuver"]
    }
}

extension CLLocationCoordinate2D: Mappable {
    // MARK: JSON
    public init?(map: Map) {
        self.init()
    }
    
    mutating public func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
    }
}
