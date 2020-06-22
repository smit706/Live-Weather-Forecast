//
//  Weather.swift
//  Weather
//
//  Created by Student on 2020-04-06.
//  Copyright © 2020 Student. All rights reserved.
//

import Foundation

struct WeatherForecastList: Codable {
    let list: [WeatherForecastData]
}

struct WeatherForecastData: Codable {
    let dt: Int64
    let main: WeatherForecastDataMain
    let weather: [WeatherForecastDataWeather]
    let dt_txt: String
    
    func getDate()->String{
        return dt_txt.components(separatedBy: " ").first!
    }
    
    func getHour()->String{
        let time = dt_txt.components(separatedBy: " ")[1]
        let hour = time.components(separatedBy: ":").first!
        return hour
    }
}

struct WeatherForecastDataMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherForecastDataWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct WeatherForcastTableViewCellData {
    let day: String
    let image: String
    let minTemp: Double
    let maxTemp: Double
    let weatherStatus: String
}

struct HourlyWeatherCollectionViewCellData {
    let hour: String
    let image: String
    let temp: Double
}

struct CurrentWeatherData: Codable {
    let id: Int
    let name: String
    let weather: [CurrentWeather]
    let main: WeatherForecastDataMain
}

struct CurrentWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct CurrentMain: Codable {
    let temp: Double
}

