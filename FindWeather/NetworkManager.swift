//
//  WeatherManager.swift
//  Clima
//
//  Created by Angela Yu on 03/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//


import UIKit


struct NetworkManager {
    
    static let shared = NetworkManager()
    
    init() {}

    func fetchWeather(urlString: String, completed: @escaping (WeatherData) -> Void) {
  
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {return}

            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                completed(decodedData)
            } catch {
                print("decode unsuccessful")
            }
        }
        task.resume()
    }
    
 
}

