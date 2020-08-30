//
//  WeatherElement.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 15/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import Foundation

struct WeatherElement: Codable {
    var main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
    
    init(main: String, weatherDescription: String, icon: String) {
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
    
//     init(json:[String:Any]) throws {
//        guard let main = json["main"] as? String else {throw SerializationError.missing("main is missing")}
//        
//        guard let description = json["description"] as? String else {throw SerializationError.missing("description is missing")}
//        
//        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
//        
//        self.main = main
//        self.weatherDescription = description
//        self.icon = icon
//    }
}
