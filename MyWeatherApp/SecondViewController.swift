//
//  SecondViewController.swift
//  MyWeatherApp
//
//  Created by USER on 20/10/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol cityweatherdata {
//    func newWeather(city : String, temperature: String)
    func newWeather(temp: String, city: String, icon: UIImage)
        
}

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var CityTextField: UITextField!
    
    @IBAction func GetWeatherButton(_ sender: Any) {
        getCityweatherfromtextfield()
        dismiss(animated: true, completion: nil)
    }
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b93bb136bfe6419cc28c2518f7b53f10"
    var weatherDataModel = WeatherDataModel2()
    
    var delegate : cityweatherdata?
    
    func getCityweatherfromtextfield() {
        let cityname = String(CityTextField.text!)
        
        let params : [String : String] = ["q" : cityname, "appID" : APP_ID ]
        
        getWeatherData2(url : WEATHER_URL, parameters : params)
        
    
    }
    //MARK NETWORKING
    
    func getWeatherData2(url : String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("success! Got it!")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.UpdateWeatherData(json: weatherJSON)
            }
            
            else{
                print("Error \(String(describing: response.result.error))")
                self.delegate!.newWeather(temp: "Connection Issues", city: "", icon: UIImage(named: "dunno.png")!)
                
            }
        }
}
    
    //MARK: -JSON parsing
    
    // write the update weather data method here
    
    func UpdateWeatherData(json : JSON){
        
        //optional  binding
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperture = Int(tempResult - 273.15)
        let temperture = "\(weatherDataModel.temperture)°c"
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.WeatherIconName = weatherDataModel.UpdateWeatherIcon(condition: weatherDataModel.condition)
            
            delegate!.newWeather(temp: temperture, city: weatherDataModel.city, icon: UIImage(named: weatherDataModel.WeatherIconName)!)
        
//    UpdateUIWithWeatherData()
        } else{
            delegate!.newWeather(temp: "Weather Unavailable", city: "I can't find you", icon: UIImage(named: "dunno.png")!)
        }
        
    }
    
//    func UpdateUIWithWeatherData(){
//        CityLabel.text = weatherDataModel.city
//        WeatherLabel.text = String(weatherDataModel.temperture)
//        WeatherLabel.text = "\(weatherDataModel.temperture)°c"
//        WeatherIcon.image  = UIImage(named: weatherDataModel.WeatherIconName)
//
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
