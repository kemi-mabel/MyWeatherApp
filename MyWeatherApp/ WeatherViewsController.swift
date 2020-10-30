//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by USER on 05/10/2020.
//

import UIKit

import CoreLocation
import Alamofire  
import SwiftyJSON



class WeatherViewsController: UIViewController, CLLocationManagerDelegate, cityweatherdata{
    
    func newWeather(cityname: String){
        
        let params : [String : String] = ["q" : cityname, "appID" : APP_ID ]
        
        getWeatherData(url : WEATHER_URL, parameters : params)
    }
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b93bb136bfe6419cc28c2518f7b53f10"
    var weatherDataModel = WeatherDataModel()

    @IBOutlet weak var WeatherLabel: UILabel!
    
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    @IBOutlet weak var CityLabel: UILabel!
    
    @IBAction func SwitchButton(_ sender: Any) {
        performSegue(withIdentifier: "cityweather", sender: self)
    }
    
    @IBAction func tempSwitch(_ sender: UISwitch) {
        stateChanged(switchState: stateSwitch)
//        if stateSwitch.isOn{
////            WeatherLabel.text = "\(weatherDataModel.temperture)°c"
//        } else {
//            WeatherLabel.text = "\(weatherDataModel.ktemp)°k"
//        }
        
    }
        
    @IBOutlet weak var stateSwitch: UISwitch!
    

    
    
    //TODO: Declare instance variables here
    let locationmanager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    setupLocationManager()
        
    }
    //set up the location manager here
    func setupLocationManager(){
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
    }
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationmanager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appID" : APP_ID ]
            
            getWeatherData(url : WEATHER_URL, parameters: params)
        
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        CityLabel.text = "You are in the spirit realm"
    }
    
    //MARK NETWORKING
    
    func getWeatherData(url : String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("success! Got it!")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.UpdateWeatherData(json: weatherJSON)
            }
            
            else{
                print("Error \(String(describing: response.result.error))")
                self.CityLabel.text = "Connection Issues"
                
            }
        }
}
    
    //MARK: -JSON parsing
    
    // write the update weather data method here
    
    func UpdateWeatherData(json : JSON){
        
        //optional  binding
        if let tempResult = json["main"]["temp"].double {
        weatherDataModel.ktemp = Int(tempResult)
        weatherDataModel.temperture = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.WeatherIconName = weatherDataModel.UpdateWeatherIcon(condition: weatherDataModel.condition)
         UpdateUIWithWeatherData()
        } else{
            CityLabel.text = "Weather  unavailable"
        }
        
    }
    
                
    //MARK: UIUPDATE
    func UpdateUIWithWeatherData(){
        CityLabel.text = weatherDataModel.city
//        WeatherLabel.text = String(weatherDataModel.temperture)
        WeatherLabel.text = "\(weatherDataModel.temperture)°c"
        WeatherIcon.image  = UIImage(named: weatherDataModel.WeatherIconName)
        
        
    }
    enum Tempunit {
       case Celcius
       case Kelvin
    }

//
//    temperature = .Celcius
    func stateChanged(switchState: UISwitch) {
        var temperature = Tempunit.Celcius;
        
        if stateSwitch.isOn{
            temperature = .Celcius
                
        } else {
            temperature = .Kelvin            }
        
        switch temperature {
           case .Celcius:
                WeatherLabel.text = "\(weatherDataModel.temperture)°c"
            case .Kelvin:
                WeatherLabel.text = "\(weatherDataModel.ktemp)°k"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cityweather" {
            let SVC = segue.destination as! SecondViewController
            SVC.delegate = self
            
        }
        
    }


}
    

