//
//  Main.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 15/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import Foundation

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(json:[String:Any]) throws {
        guard let temp = json["temp"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let feelsLike = json["feels_like"] as? Double else {throw SerializationError.missing("feels like is missing")}
        
        guard let tempMin = json["tempMin"] as? Double else {throw SerializationError.missing("tempMin is missing")}
        
        guard let tempMax = json["tempMax"] as? Double else {throw SerializationError.missing("tempMax is missing")}
        
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
}
