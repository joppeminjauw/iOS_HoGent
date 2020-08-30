//
//  LocationController.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 14/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationController {
        
    static let APIKey = "d4b6e8b492c553f06842358ff2461e4a"
    
    static func getForecastFromCoord (lat: Double, long: Double, completion: @escaping (Weather?) -> ()) {
                
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(APIKey)&units=metric"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
                        
            var json: Weather?
            do {
                json = try JSONDecoder().decode(Weather.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
                    
            completion(result)
            
        }).resume()
    }
    
    static func getForecastFromName (name: String, completion: @escaping (Weather?) -> ()) {
                
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(APIKey)&units=metric"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
                        
            var json: Weather?
            do {
                json = try JSONDecoder().decode(Weather.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
                                    
            completion(result)
            
        }).resume()
    }
}
