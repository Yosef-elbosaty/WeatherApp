//
//  ViewController.swift
//  WeatherApp
//
//  Created by yosef elbosaty on 5/9/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "ad4d09a039070077d64a429df40b8385"
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherData()
    
    //Outlets Declaration
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    //MARK:- Networking
    func getWeatherData(url: String, Parameters : [String:String]){
        AF.request(url, method: .get, parameters: Parameters).responseJSON{ (response) in
            switch response.result{
            case .success:
             
                let weatherJSON : JSON = JSON(response.value!)
           
                self.updateWeatherData(json: weatherJSON)
                
            case .failure:
                print("\(String(describing: response.error))")
                self.cityName.text = "Connection Issues"
            }
        }
        }
    
    //MARK:- JSON Parsing
    func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double{
        weatherData.temperature = Int(tempResult - 273.15)
            weatherData.cityName = json["name"].stringValue
            weatherData.condition = json["weather"][0]["id"].intValue
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
          updateUI()
        }else{
            cityName.text = "Weather Unavailable!"
        }
    }
    
    
    //MARK:- Location Manager Delegate Methods:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        let longitude = String(location.coordinate.longitude)
        let latitude = String(location.coordinate.latitude)
        let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appID" : appID]
        getWeatherData(url: weatherURL, Parameters: params)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityName.text = "Location Unavailable!"
    }
    
    //MARK:- UI Updates
    func updateUI(){
        cityName.text = weatherData.cityName
        weatherConditionImage.image = UIImage(named: weatherData.weatherIconName)
        tempLabel.text = "\(weatherData.temperature)°"
     
    }

    func UserEnteredCityName(city: String) {
        let params : [String:String] = ["q" : city, "appID" : appID]
        getWeatherData(url: weatherURL, Parameters: params)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destination = segue.destination as! ChangeCityViewController
            destination.delegate = self
        }
    }
}

