//
//  Coord.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 15/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import Foundation

struct Coord: Codable {
    let lon, lat: Double
    
    init(json:[String:Any]) throws {
        guard let lon = json["lon"] as? Double else {throw SerializationError.missing("longitude is missing")}
        
        guard let lat = json["lat"] as? Double else {throw SerializationError.missing("latitude is missing")}
        
        self.lon = lon
        self.lat = lat
    }
}
