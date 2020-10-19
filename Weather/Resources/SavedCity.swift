//
//  SavedCity.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/17/20.
//

import Foundation

enum SavedCity: String {

    static let all: [SavedCity] = [.cairo, .munich]

    case cairo = "Cairo"
    case munich = "Munich"

    var weather: [Weather] {
        Service.shared.getWeatherDataFor(city: self)
    }
}
