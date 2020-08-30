//
//  CompareViewController.swift
//  MyWeather
//
//  Created by Joppe Minjauw on 30/08/2020.
//  Copyright © 2020 Cryptonic. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var clearBtn: UIButton!
    
    var locations: [Weather]?
    var selectedLoc: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bgDay")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        self.titleLabel.textColor = .white

        if (self.locations!.isEmpty){
            self.titleLabel.text = "No locations saved"
        }else {
            self.titleLabel.text = "\(self.locations!.count) saved locations"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        
        let weather = locations?[indexPath.row]
        cell.weatherImg.image = UIImage(named: weather?.weather[0].icon ?? "default")
        cell.nameLabel.text = weather!.name
        cell.tempLabel.text = "\(weather!.main.temp)°C"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLoc = self.locations?[indexPath.row]
        self.performSegue(withIdentifier: "compareToWeatherSegue", sender: self)
    }
    
    @IBAction func clearLocations(_ sender: Any) {
        var dialogMessage = UIAlertController(title: "Clear Locations", message: "Are you sure you want to clear all locations?", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.locations?.removeAll()
            self.tableView.reloadData()
            self.viewDidLoad()
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.viewDidLoad()
        }

        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        self.present(dialogMessage, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WeatherViewController
        vc.currentWeather = self.selectedLoc
        vc.savedLocations = self.locations!
    }

}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
}
