//
//  APIManager.swift
//  WeatherApp
//
//  Created by Serg Kalinin on 19/11/2018.
//  Copyright © 2018 Serg Kalinin. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    init?(JSON:[String: AnyObject])
}

protocol FinalUrlPoint {
    var baseUrl: URL { get }
    var path: String { get }
    var request:URLRequest { get }
    
}

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T:JSONDecodable>(request:URLRequest, parse: @escaping([String: AnyObject]) -> T?, comletionHandler: @escaping(APIResult<T>) -> Void)
  
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: WANetworkingErrorDomain, code: MissingHTTPResponseError , userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                        
                    }
                default:
                    print("HTTP Status is \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    
    func fetch<T>(request:URLRequest, parse:@escaping([String: AnyObject]) -> T?, comletionHandler:@escaping (APIResult<T>) -> Void) {
    
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async(execute: {
                guard let json = json else {
                    if let error = error {
                        comletionHandler(.Failure(error))
                    }
                    return
                }
                if let value = parse(json) {
                    comletionHandler(.Success(value))
                } else {
                    let error = NSError(domain: WANetworkingErrorDomain, code: UnexpextedResponseError, userInfo: nil)
                    comletionHandler(.Failure(error))
                }
            })
        }
        dataTask.resume()
    }
    
}
