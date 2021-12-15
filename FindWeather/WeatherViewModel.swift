//
//  WeatherViewModel.swift
//  ClimaSwiftUI
//
//  Created by VINH HOANG on 10/11/2021.
//

import SwiftUI
import MapKit
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weatherModel: WeatherModel?
    
    @Published var city: String = ""
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9fa635683e615b50344af640e3e3f7b7&units=metric"
    
    var defaultLocation = CLLocation(latitude: 21.0278, longitude: 105.8412)
    
    func fetchWeatherDataByCoordinate() {
        let lat = defaultLocation.coordinate.latitude
        let lon = defaultLocation.coordinate.longitude
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        getWeatherData(for: urlString)
    }
    
    
    func fetchWeather(for cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        getWeatherData(for: urlString)
    }
    
    func getWeatherData(for url: String) {
        NetworkManager.shared.fetchWeather(urlString: url) { weatherdata in
            //            self.locationManager.stopUpdatingLocation()
            let id = weatherdata.weather[0].id
            let cityName = weatherdata.name
            let temp = weatherdata.main.temp
            DispatchQueue.main.async {
                self.weatherModel = WeatherModel(conditionId: id,
                                                 cityName: cityName,
                                                 temperature: temp
                )
            }
        }
    }
    
    // MARK: - CLLocationDelegate
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
       // locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
    }
    
    func requestAllowLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        
        if let lastestLocation = locations.first  {
            defaultLocation = lastestLocation
            fetchWeatherDataByCoordinate()
        }
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
    }
    
}



