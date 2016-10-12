//
//  Route.swift
//  Routes
//
//  Created by Mark Jackson on 7/18/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import ObjectMapper
import CoreLocation

struct HERERoutePlacesAPIResponse: Mappable {
    var results: [PlaceAutoCompleteResult]!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
}

struct PlaceAutoCompleteResult: Mappable {
    var title: String!
    var highlightedTitle: String!
    var vicinity: String!
    var highlightedVicinity: String!
    var category: String!
    private var _position: [Double]!
    var position: (Double, Double) {
        get {
            return (_position[0], _position[1])
        }
    }
    var id: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        highlightedTitle <- map["highlightedTitle"]
        vicinity <- map["vicinity"]
        highlightedVicinity <- map["highlightedVicinity"]
        category <- map["category"]
        _position <- map["position"]
        id <- map["id"]
    }
}

struct HERERouteDirectionsAPIResponse: Mappable {
    var metaInfo: RouteResponseMetaInfo!
    var routes: [RouteType]!
    var language: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        metaInfo <- map["response.metaInfo"]
        routes <- map["response.routes"]
        language <- map["response.language"]
    }
}

struct RouteResponseMetaInfo: Mappable {
    var timestamp: String!
    var mapVersion: String!
    var moduleVersion: String!
    var interfaceVersion: String!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        timestamp <- map["timestamp"]
        mapVersion <- map["mapVersion"]
        moduleVersion <- map["moduleVersion"]
        interfaceVersion <- map["interfaceVersion"]
    }
}

struct RouteType: Mappable {
    var routeId: String!
    var waypoints: [RouteWaypoint]!
    var legs: [RouteLeg]!
    var summary: RouteSummary!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        waypoints <- map["waypoint"]
        legs <- map["leg"]
        routeId <- map["routeId"]
        summary <- map["summary"]
    }
}


struct RouteWaypoint: Mappable {
    var linkId: String!
    var mappedPosition: CLLocationCoordinate2D!
    var originalPosition: CLLocationCoordinate2D!
    var type: String!
    var spot: Double?
    var sideOfStreet: String!
    var mappedRoadName: String!
    var label: String!
    var shapeIndex: Int!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        linkId <- map["linkId"]
        mappedPosition <- map["mappedPosition"]
        originalPosition <- map["originalPosition"]
        type <- map["type"]
        spot <- map["spot"]
        sideOfStreet <- map["sideOfStreet"]
        mappedRoadName <- map["mappedRoadName"]
        label <- map["label"]
        shapeIndex <- map["shapeIndex"]
    }
}

struct RouteLeg: Mappable {
    var start: RouteWaypoint!
    var end: RouteWaypoint!
    var length: Double!
    var travelTime: Double!
    var maneuver: [RouteManeuver]!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        start <- map["start"]
        end <- map["end"]
        length <- map["length"]
        travelTime <- map["travelTime"]
        maneuver <- map["maneuver"]
    }
}

struct RouteManeuver: Mappable {
    var id: String!
    var position: CLLocationCoordinate2D!
    var instruction: String!
    var length: Double!
    var travelTime: Double!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        position <- map["position"]
        instruction <- map["instruction"]
        length <- map["length"]
        travelTime <- map["travelTime"]
    }
}

struct RouteSummary: Mappable {
    var distance: Double!
    var trafficTime: Double!
    var baseTime: Double!
    var text: String!
    var travelTime: Double!
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        distance <- map["distance"]
        trafficTime <- map["trafficTime"]
        baseTime <- map["baseTime"]
        text <- map["text"]
        travelTime <- map["travelTime"]
    }
}

extension CLLocationCoordinate2D: Mappable {
    // MARK: JSON
    public init?(_ map: Map) {
        self.init()
    }
    
    mutating public func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
