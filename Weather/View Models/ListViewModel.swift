//
//  ListViewModel.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import Foundation
import Combine

class ListViewModel {

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeZone = .none
        return formatter
    }()

    @Published var sectionHeaders: [String] = []
    @Published var dataSource: [[Weather]] = []
    @Published var reloadData: Void = ()
    var cityName: String

    init(city: City) {
        cityName = city.fullName
        Service.shared.getWeatherDataForCity(withID: city.id) { [weak self] weatherArray in
            self?.loadDataFrom(weatherArray: weatherArray)
        }
    }

    init(savedCity: SavedCity) {
        self.cityName = savedCity.rawValue
        loadDataFrom(weatherArray: savedCity.weather)
    }

    private func loadDataFrom(weatherArray: [Weather]) {
        // Group by date
        let groupedDictionary = Dictionary(grouping: weatherArray, by: { [weak self] in
            self?.dateFormatter.string(from: $0.date)
        })

        // Convert back to array and sort
        let dataSource = Array(groupedDictionary.values).sorted { $0[0].date < $1[0].date }

        // Update data source
        self.dataSource = dataSource

        // Update Section Headers
        sectionHeaders = dataSource.compactMap { [weak self] in
            self?.dateFormatter.string(from: $0.first?.date ?? Date())
        }

        // Reload
        reloadData = (())
    }
}
