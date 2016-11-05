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
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "082f85a53bf94ae987b3e5e281a71e51"
    
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
//    func getWeatherByCity(city: String) {
//        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
//        getWeather(weatherRequestURL)
//    }
    
    func getWeather(weatherRequestURL: NSURL) {
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
           
            if let networkError = error {
                self.delegate.didNotGetWeather(networkError)
            }
            else {
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now use that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather)
//                    
//                    print("Date and time: \(weather["dt"]!)")
//                    print("City: \(weather["name"]!)")
//                    
//                    print("Longitude: \(weather["coord"]!["lon"]!!)")
//                    print("Latitude: \(weather["coord"]!["lat"]!!)")
//                    
//                    print("Weather ID: \(weather["weather"]![0]!["id"]!!)")
//                    print("Weather main: \(weather["weather"]![0]!["main"]!!)")
//                    print("Weather description: \(weather["weather"]![0]!["description"]!!)")
//                    print("Weather icon ID: \(weather["weather"]![0]!["icon"]!!)")
//                    
//                    print("Temperature: \(weather["main"]!["temp"]!!)")
//                    print("Humidity: \(weather["main"]!["humidity"]!!)")
//                    print("Pressure: \(weather["main"]!["pressure"]!!)")
//                    
//                    print("Cloud cover: \(weather["clouds"]!["all"]!!)")
//                    
//                    print("Wind direction: \(weather["wind"]!["deg"]!!) degrees")
//                    print("Wind speed: \(weather["wind"]!["speed"]!!)")
//                    
//                    print("Country: \(weather["sys"]!["country"]!!)")
//                    print("Sunrise: \(weather["sys"]!["sunrise"]!!)")
//                    print("Sunset: \(weather["sys"]!["sunset"]!!)")
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetWeather(jsonError)
                }
            }
            
        }
        
        dataTask.resume()
    }
}
