//
//  HomeViewController.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 14/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var appLogo: UIImageView!
    @IBOutlet var locationBtn: UIButton!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var currentWeather: Weather?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bgDay")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .white
            
        searchBar.delegate = self
    }
     
    @IBAction func myLocationPressed(_ sender: Any) {
        // when button is pressed we ask for permission to use location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.main.async {
                LocationController.getForecastFromName(name: locationString) { (weather: Weather?) in
                    self.currentWeather = weather
                    group.leave()
                }
            }
                
            group.notify(queue: .main) {
                self.performSegue(withIdentifier: "weatherSegue", sender: self)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()

            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            LocationController.getForecastFromCoord(lat: lat, long: long) { (weather: Weather?) in
                self.currentWeather = weather
                group.leave()
            }
        }
            
        group.notify(queue: .main) {
            self.performSegue(withIdentifier: "weatherSegue", sender: self)
        }
    }
    
        // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WeatherViewController
        vc.currentWeather = self.currentWeather
    }
}
