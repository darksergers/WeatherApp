//
//  APiWeatherManager.swift
//  WeatherApp
//
//  Created by Serg Kalinin on 21/11/2018.
//  Copyright © 2018 Serg Kalinin. All rights reserved.
//

import Foundation
struct Coordinates {
    let latitude:Double
    let longitude:Double
}

enum ForecastType: FinalUrlPoint {
    var baseUrl: URL {
        return URL(string: "https://api.forecast.io")!
    }
    
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.longitude),\(coordinates.latitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseUrl)
        return URLRequest(url: url!)
    }
    
    case Current(apiKey:String, coordinates:Coordinates)

}

final class APIWeatherManager:APIManager {
    
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let apiKey:String
    
    init(sessionConfiguration:URLSessionConfiguration, apiKey:String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey:String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinates:Coordinates, completionHandler:@escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates)
        fetch(request: request.request, parse: { (json) -> CurrentWeather? in
            if let dictionary = json["currently"] as? [String:AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, comletionHandler: completionHandler)
    }
}
