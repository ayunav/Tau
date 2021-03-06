//
//  WeatherGetter.swift
//  Tau
//
//  Created by Ayuna NYC on 11/3/16.
//  Copyright © 2016 Ayuna NYC. All rights reserved.
//

import Foundation

// MARK: WeatherGetterDelegate
// ===========================
// WeatherGetter should be used by a class or struct, and that class or struct
// should adopt this protocol and register itself as the delegate.
// The delegate's didGetWeather method is called if the weather data was
// acquired from OpenWeatherMap.org and successfully converted from JSON into
// a Swift dictionary.
// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.

protocol WeatherGetterDelegate {
    func didGetWeather(_ weather: Weather)
    func didNotGetWeather(_ error: Error)
}


class WeatherGetter {
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    fileprivate let openWeatherMapAPIKey = "082f85a53bf94ae987b3e5e281a71e51"
    
    fileprivate var delegate: WeatherGetterDelegate
    
    
    init(delegate: WeatherGetterDelegate)
    {
        self.delegate = delegate
    }
    
    
    func getWeatherByCity(_ city: String)
    {
        guard let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)") else {
            let error = NSError(domain: "WeatherFetchingURLCreation", code: 0, userInfo: nil)
            self.delegate.didNotGetWeather(error)
            return
        }
        getWeather(weatherRequestURL)
    }
    
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double)
    {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL)
    }
    
    
    fileprivate func getWeather(_ weatherRequestURL: URL)
    {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        let task = session.dataTask(with: weatherRequestURL, completionHandler: { (data, response, error) -> Void in
            guard let _data = data else {
                self.delegate.didNotGetWeather(error!)
                return
            }
            do {
                // Try to convert that data into a Swift dictionary
                guard let weatherData = try JSONSerialization.jsonObject(with: _data, options: .mutableContainers) as? [String: AnyObject] else {
                    self.delegate.didNotGetWeather(error!)
                    return
                }
                
                // If we made it to this point, we've successfully converted the
                // JSON-formatted weather data into a Swift dictionary.
                // Let's now use that dictionary to initialize a Weather struct.
                let weather = Weather(weatherData: weatherData)

                // Now that we have the Weather struct, let's notify the view controller,
                // which will use it to display the weather to the user.
                self.delegate.didGetWeather(weather)
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
