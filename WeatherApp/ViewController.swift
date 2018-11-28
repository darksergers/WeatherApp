//
//  ViewController.swift
//  WeatherApp
//
//  Created by Serg Kalinin on 09/11/2018.
//  Copyright © 2018 Serg Kalinin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func refreshButtonTap(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "630cc8f3c1df1d0e9ca6abd1d950385f")
    let coordinates = Coordinates(latitude:59.939, longitude:30.316)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeatherData()
        
    }
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func getCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: self.coordinates) { (result) in
            self.toggleActivityIndicator(on: false)
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                let alertControler = UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertControler.addAction(okAction)
                self .present(alertControler, animated: true, completion: nil)
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text =  currentWeather.pressureString
        self.temperatureLabel.text =  currentWeather.temperatureString
        self.appearentTemperatureLabel.text =  currentWeather.apparentTemperatureString
        self.humidityLabel.text = currentWeather.humidityString
        
    }


}


