//
//  ViewController.swift
//  Tau
//
//  Created by Ayuna NYC on 11/3/16.
//  Copyright © 2016 Ayuna NYC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let weather = WeatherGetter()
        weather.getWeather("newyork")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

