//
//  WeatherViewController.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 16/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var addLocationBtn: UIButton!
    @IBOutlet var myLocationsBtn: UIButton!
    
    var currentWeather: Weather?
    var savedLocations: [Weather] = []
    var dialogMessage: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        let icon = self.currentWeather?.weather[0].icon
        
        if (icon?.last == "d") {
            UIImage(named: "bgDay")?.draw(in: self.view.bounds)
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.backgroundColor = .white
        } else {
            UIImage(named: "bgNight")?.draw(in: self.view.bounds)
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.backgroundColor = .lightGray  
        }
        
        self.tempLabel.textColor = .white
        self.descLabel.textColor = .white
        self.nameLabel.textColor = .white
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.searchBar.text = self.currentWeather?.name
        self.searchBar.delegate = self

        
        self.weatherImage.image = UIImage(named: self.currentWeather?.weather[0].icon ?? "default")
        self.tempLabel.text = "\(self.currentWeather?.main.temp ?? 0.0)°C"
        self.descLabel.text = "\(self.currentWeather?.weather[0].weatherDescription ?? "")"
        self.nameLabel.text = "\(self.currentWeather?.name ?? "Unknown")"
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
                self.viewDidLoad()
            }
        }
    }

    @IBAction func addLocationClicked(_ sender: Any) {
        if self.savedLocations.contains(where: { $0.name == self.currentWeather!.name }){
            self.dialogMessage = UIAlertController(title: "Location already added", message: "Location '\( self.currentWeather!.name)' has already been added", preferredStyle: .alert)

            self.present(dialogMessage, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.5,repeats: false, block: { _ in self.dialogMessage.dismiss(animated: true, completion: nil)})
        } else {
            self.savedLocations.append((self.currentWeather)!)
            
            self.dialogMessage = UIAlertController(title: "Location added", message: "Location '\( self.currentWeather!.name)' has been added for comparison", preferredStyle: .alert)

            self.present(dialogMessage, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.5,repeats: false, block: { _ in self.dialogMessage.dismiss(animated: true, completion: nil)})
        }
    }
    
    @IBAction func showMyLocations(_ sender: Any) {
        self.performSegue(withIdentifier: "compareLocationsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CompareViewController
        vc.locations = self.savedLocations
    }

}
