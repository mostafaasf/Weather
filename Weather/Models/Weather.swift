//
//  Weather.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/15/20.
//

import Foundation

struct Weather {
    let date: Date
    let temperature: Double
    let iconName: String
}

extension Array where Element == Weather {
    init(data: Data?) {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any],
              let list = json["list"] as? [[String: Any]]
        else {
            self = []
            return
        }
        self = list.compactMap { weatherDictionary -> Weather? in
            guard let timeInterval = weatherDictionary["dt"] as? TimeInterval,
                  let mainDictionary = weatherDictionary["main"] as? [String: Any],
                  let temperature = mainDictionary["temp"] as? Double,
                  let weatherArray = weatherDictionary["weather"] as? [[String: Any]],
                  let iconName = weatherArray.first?["icon"] as? String
            else {
                return nil
            }
            return Weather(
                date: Date(timeIntervalSince1970: timeInterval),
                temperature: temperature,
                iconName: iconName
            )
        }
    }
}
