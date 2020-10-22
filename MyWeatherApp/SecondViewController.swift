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
    func newWeather(cityname: String)
        
}

class SecondViewController: UIViewController {

        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var CityTextField: UITextField!
    
    @IBAction func GetWeatherButton(_ sender: Any) {
        let cityname = CityTextField.text!

        delegate?.newWeather(cityname: cityname)
        dismiss(animated: true, completion: nil)
    }
    var delegate : cityweatherdata?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
