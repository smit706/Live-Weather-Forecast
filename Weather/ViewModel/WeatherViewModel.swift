//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Student on 2020-04-05.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewModel: NSObject {
    
    var currentLocation:((CLLocation)->())?
    let locationManager = LocationManager()
    var daysDataDict = [(String,[WeatherForecastData])]()
    var currentTempData:CurrentWeatherData?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func makeDayWiseDataPartition(WeatherForecastList: [WeatherForecastData]) -> [(String,[WeatherForecastData])] {
        
        let dict = Dictionary.init(grouping: WeatherForecastList, by: { $0.getDate() })
        let sortedDict = dict.sorted(by: { $0.key < $1.key })
        return sortedDict
    }
    
    func getDayFromDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.string(from: date!)
        return dayString
    }
}

//MARK: - Configure cell

extension WeatherViewModel {
    
    func configureWeatherForecastTableViewCell(dayData: (String, [WeatherForecastData])) -> WeatherForcastTableViewCellData {
        let arrWeatherData = dayData.1
        let randomData = arc4random_uniform(UInt32(arrWeatherData.count))
        let singleDayData = arrWeatherData[Int(randomData)]

        return WeatherForcastTableViewCellData.init(day: getDayFromDate(dateString: singleDayData.dt_txt), image: singleDayData.weather.first!.icon, minTemp: singleDayData.main.temp_min, maxTemp: singleDayData.main.temp_max, weatherStatus: singleDayData.weather.first!.main)
    }
    
    func configureHourlyWeatherCollectionCellData(hourData: WeatherForecastData) -> HourlyWeatherCollectionViewCellData {
        let hour = hourData.getHour()
        return HourlyWeatherCollectionViewCellData.init(hour: hour, image: hourData.weather.first!.icon, temp: hourData.main.temp)
    }
}

//MARK: - Service call

extension WeatherViewModel {
    func callFetchCurrentWeatherDataAPI(location:CLLocation, onSuccess: @escaping (()->()), onFailure: @escaping ((String)->())) {
        
        NetworkManager.sharedInstance.fetchWeatherData(urlEndPoint: "weather", params: ["lat":location.coordinate.latitude,"lon":location.coordinate.longitude], onSuccess: { (responseData) in
            if let weatherData = try? JSONDecoder().decode(CurrentWeatherData.self, from: responseData) {
                self.currentTempData = weatherData
                onSuccess()
            }
            else {
                onFailure("Error in decode data")
            }
        }) { (error) in
            onFailure(error)
        }
    }

    func callFetchWeatherForecastDataAPI(location:CLLocation, onSuccess: @escaping (()->()), onFailure: @escaping ((String)->())) {
        
        NetworkManager.sharedInstance.fetchWeatherData(urlEndPoint: "forecast", params: ["lat":location.coordinate.latitude,"lon":location.coordinate.longitude], onSuccess: { (responseData) in
            if let weatherData = try? JSONDecoder().decode(WeatherForecastList.self, from: responseData) {
                //print(weatherData)
                self.daysDataDict = self.makeDayWiseDataPartition(WeatherForecastList: weatherData.list)
                onSuccess()
            }
            else{
                onFailure("Error in decode data")
            }
        }) { (error) in
            onFailure(error)
        }
    }
}

//MARK: - Location Service Delegate

extension WeatherViewModel: LocationServiceDelegate {
    func currentLocation(location: CLLocation) {
        if let currentLocation = self.currentLocation {
            currentLocation(location)
        }
    }
}
