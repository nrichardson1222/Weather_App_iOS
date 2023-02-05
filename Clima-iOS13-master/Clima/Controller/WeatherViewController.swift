//
//  ViewController.swift
//  Clima
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    //initialization of weather manager struct
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //asks the user on opening the app if location can be accessed
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        //sets this VC as the weather manager delegate and has the required method of did update weather
        weatherManager.delegate = self
        //This delegate is being used to allow the search button functionality when enter or return is pressed on keyboard. THis allows the textfield to communicate with what is going on
        //the delegate is essentially a way for the weatherviewcontroller to sign up for the protocl which includes methoes like didbeginediting etc
        //here we are setting the delegate property of the uitextfield to be this view controller
        searchTextField.delegate = self
       
    }

}

//UITextFieldDelegate
//This allows the textfield to communicate with what is happening on it
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //end editing dismisses the keyboard
        searchTextField.endEditing(true)
    }
    //This method allows user to hit return on keyboard instead of hitting search button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //end editing dismisses the keyboard
        searchTextField.endEditing(true)
        return true
    }
    //triggered if user taps elsewhere
    //for this method it passes in textfield that triggers this method
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            //returns false so keyboard doesnt disappear
            return false
        }
    }
    //triggered when textfields are done being edited. It clears the textfield and fetches weather for that city
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}

//WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {//this dispatch queue is needed so if the update takes a while the app does not slow down. If the API call takes a while then the UI will be frozen when the networking is taking place so this prevents this from happening
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            //gets the location of the device by tracking longitude and latitude
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //fetches the weather using this as input parameters
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
