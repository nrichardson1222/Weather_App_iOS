//
//  WeatherModel.swift
//  Clima
//


import Foundation

struct WeatherModel {
    
    //this struct is used to get the condition 
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        //I am formating the string to have no decimal place
        return String(format: "%.0f", temperature)
    }
    //this is parsed using this website https://openweathermap.org/weather-conditions
    //here I am using SF symbols which have build in light and dark modes
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
