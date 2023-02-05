//
//  WeatherData.swift
//  Clima
//


import Foundation
//weather data struct. the codable protocal means that it can decode it from the json format. This object is made in the weather manager class when json decode is called
struct WeatherData: Codable {
    let name: String //the name of the city
    let main: Main //used to store temperature
    let weather: [Weather] //gets the weather condition like cloudy sunny etc
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
//    let description: String
    let id: Int
}
