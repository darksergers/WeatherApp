//
//  File.swift
//  WeatherApp
//
//  Created by Serg Kalinin on 12/11/2018.
//  Copyright © 2018 Serg Kalinin. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature:Double
    let apparentTemperature:Double
    let humidity:Double
    let pressure:Double
    let icon:UIImage
}
extension CurrentWeather {
    var pressureString:String {
        return "\(Int(pressure * 0.750062)) mm"
    }
    var temperatureString:String {
        return "\(Int(5 / 9 * (temperature - 32) )) ˚C"
    }
    var apparentTemperatureString:String {
        return "\(Int(5 / 9 * (apparentTemperature - 32))) ˚C"
    }
    var humidityString:String {
        return "\(Int(humidity * 100)) %"
    }
    
}
extension CurrentWeather: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
        let apparentTemperature = JSON["apparentTemperature"] as? Double,
        let humidity = JSON["humidity"] as? Double,
        let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String else {
                return nil
        }
        let icon = WeatherIconManager(rawValue: iconString).image
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.icon = icon
    }
}