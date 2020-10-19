//
//  Service.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/15/20.
//

import Foundation

class Service {

    static let shared = Service()

    private var cities: [City] = []

    func getAllCities() -> [City] {
        guard cities.isEmpty else {
            return cities
        }
        guard let path = Bundle.main.path(forResource: "city.list.min", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let cities = try? JSONDecoder().decode([City].self, from: data)
        else { return [] }
        self.cities = cities
        return cities
    }

    func getWeatherDataForCity(withID id: Int, completionHandler: @escaping (([Weather]) -> Void)) {
        guard let url = URL(
            string: "https://api.openweathermap.org/data/2.5/forecast?id=\(id)&units=metric&appid=a386a0ef55157fed8f1b20aafb81e591"
        ) else {
            completionHandler([])
            return
        }

        URLSession.shared.dataTask(with: url) { data,_,_ in
            completionHandler(.init(data: data))
        }.resume()
    }

    func getWeatherDataFor(city: SavedCity) -> [Weather] {
        guard let path = Bundle.main.path(forResource: city.rawValue, ofType: "json") else { return [] }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        return .init(data: data)
    }

    func getImage(withName name: String, completionHandler: @escaping ((Data?) -> Void)) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(name)@4x.png") else {
            completionHandler(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data,_,_ in
            completionHandler(data)
        }.resume()
    }
}
