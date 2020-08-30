//
//  Weather.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 15/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let main: Main
    let id: Int
    let name: String
    
    init(json:[String:Any]) throws {
        guard let id = json["id"] as? Int else {throw SerializationError.missing("id is missing")}
        
        guard let name = json["name"] as? String else {throw SerializationError.missing("name is missing")}
        
        self.name = name
        self.id = id
        self.coord = try Coord(json: json["coord"] as? [String:Any] ?? [:])
        
        var weathers = [WeatherElement]()
        let jsonWeather = json["weather"] as! [AnyObject]
        for weather in jsonWeather {
            let main = weather["main"] as! String
            let description = weather["description"] as! String
            let icon = weather["icon"] as! String
            weathers.append(WeatherElement(main: main, weatherDescription: description, icon: icon))
        }
        self.weather = weathers
        self.main = try Main(json: json["main"] as? [String:Any] ?? [:])
        
    }
}

enum SerializationError:Error {
    case missing(String)
    case invalid(String, Any)
}
