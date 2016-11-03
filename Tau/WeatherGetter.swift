//
//  WeatherGetter.swift
//  Tau
//
//  Created by Ayuna NYC on 11/3/16.
//  Copyright © 2016 Ayuna NYC. All rights reserved.
//

import Foundation

class WeatherGetter {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "082f85a53bf94ae987b3e5e281a71e51"
    
    func getWeather(city: String) {
        
        let session = NSURLSession.sharedSession()
        
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                print("Error:\n\(error)")
            }
            else {
                print("Raw data:\n\(data!)")
                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("Human readable data:\n\(dataString!)")
            }
            
        }
        
        dataTask.resume()
    }
}
