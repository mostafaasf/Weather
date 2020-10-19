//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import UIKit
import Combine

class WeatherViewModel {

    @Published var icon: UIImage? = UIImage()
    var temperature: String
    var time: String

    init(weather: Weather) {
        temperature = "\(Int(weather.temperature.rounded())) °C"
        time = DateFormatter.localizedString(from: weather.date, dateStyle: .none, timeStyle: .short)
        Service.shared.getImage(withName: weather.iconName) { [weak self] data in
            guard let data = data, let image = UIImage(data: data) else { return }
            self?.icon = image
        }
    }

}
