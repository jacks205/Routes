//
//  Route.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import ObjectMapper
import CoreLocation

struct DirectionsResponse: Mappable {
    var geocodedWaypoints: [GeocodedWaypoint]!
    var routes: [Route]!
    var status: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        geocodedWaypoints <- map["geocoded_waypoints"]
        routes <- map["routes"]
        status <- map["status"]
    }
}

struct GeocodedWaypoint: Mappable {
    var status: String!
    var placeID: String!
    var types: [String]!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        status <- map["geocoder_status"]
        placeID <- map["place_id"]
        types <- map["types"]
    }
}

struct Route: Mappable {
    var bound: Bound!
    var copyrights: String!
    var legs: [Leg]!
    var polyline: Polyline!
    var summary: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        bound <- map["bounds"]
        legs <- map["legs"]
        copyrights <- map["copyrights"]
        polyline <- map["overview_polyline"]
        summary <- map["summary"]
    }
}

extension CLLocationCoordinate2D: Mappable {
    // MARK: JSON
    public init?(_ map: Map) {
        self.init()
    }
    
    mutating public func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
    }
}

struct Bound: Mappable {
    private var northEast: CLLocationCoordinate2D!
    private var southWest: CLLocationCoordinate2D!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        northEast <- map["northeast"]
        southWest <- map["southwest"]
    }
}

struct Leg: Mappable {
    var distance: RouteValue!
    var duration: RouteValue!
    var traffic: RouteValue!

    var endAddress: String!
    var endLocation: CLLocationCoordinate2D!
    
    var startAddress: String!
    var startLocation: CLLocationCoordinate2D!
    
    var steps: [Step]!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
        traffic <- map["duration_in_traffic"]
        
        endAddress <- map["end_address"]
        endLocation <- map["end_location"]
        
        startAddress <- map["start_address"]
        startLocation <- map["start_location"]
        
        steps <- map["steps"]
    }
}

struct Step: Mappable {
    var distance: Int!
    var distanceText: String!
    var duration: Int!
    var durationText: String!
    
    var endLocation: CLLocationCoordinate2D!
    var startLocation: CLLocationCoordinate2D!
    var htmlInstructions: String!
    
    var polyline: Polyline!
    var travelMode: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        distance <- map["distance"]["value"]
        distanceText <- map["distance"]["text"]
        duration <- map["duration"]["value"]
        durationText <- map["duration"]["text"]
        
        endLocation <- map["end_location"]
        startLocation <- map["start_location"]
        htmlInstructions <- map["html_instructions"]
        
        polyline <- map["polyline"]
        travelMode <- map["travel_mode"]
    }
}

struct Polyline: Mappable {
    var points: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        points <- map["points"]
    }
}

struct RouteValue: Mappable {
    var text: String!
    var value: Int!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}
