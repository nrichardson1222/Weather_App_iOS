//
//  WeatherManager.swift
//  Clima
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    //this is the beginning of the url for the API. I do not have the location part of the query that is appended later but I have my API key and the units
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8576b21d6284b609d857dee0cfdc9799&units=imperial"
    //question mark shows the beginning of the query we put into the api
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        //changes the url to include the latitude and longigude in the search query
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    //here is the steps for networking. I create the url object and pass in the url string, create the URL session, give session a tast and start the task
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {//creates a optional url just in case there is error in it. I use optional binding for this
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return //this means exit out of this function
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    //function to parse the JSON data I get from the Weatherdata API call
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {//weatherdata is a codable object so it fits this requirement
            //this creates a weatherdata object and stores it in decodedData variable
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            //creates weather object from weather model using these variables
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}


