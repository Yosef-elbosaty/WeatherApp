//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by yosef elbosaty on 5/9/20.
//  Copyright © 2020 yosef elbosaty. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func UserEnteredCityName(city: String)
}

class ChangeCityViewController: UIViewController {

    var delegate : ChangeCityDelegate?
    @IBOutlet weak var changeCityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        let cityName = changeCityTextField.text!
        delegate?.UserEnteredCityName(city: cityName)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
