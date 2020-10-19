//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import UIKit
import Combine

class CitiesViewModel: NSObject {

    @Published private var allCities: [City] = []
    @Published private var searchResultCities: [City] = []
    private var state: State = .online
    private let allSavedCities = SavedCity.all

    @Published var searchResults: [String] = []
    @Published var isDone: Bool = true
    @Published var hideSearchBar = false

    override init() {
        super.init()

        DispatchQueue.global().async { [weak self] in
            self?.allCities = Service.shared.getAllCities()
        }

        $allCities.map { !$0.isEmpty }.assign(to: &$isDone)
        $searchResultCities.map { $0.map { $0.fullName } }.assign(to: &$searchResults)
    }

    func city(for indexPath: IndexPath) -> City {
        return searchResultCities[indexPath.row]
    }

    func listViewModel(for indexPath: IndexPath) -> ListViewModel {
        switch state {
        case .online:
            return ListViewModel(city: searchResultCities[indexPath.row])
        case .offline:
            return ListViewModel(savedCity: allSavedCities[indexPath.row])
        }
    }

    func didChangeSegmentedControlTo(value: Int) {
        state = State(rawValue: value) ?? .online
        switch state {
        case .online:
            searchResults = []
            hideSearchBar = false
        case .offline:
            searchResults = allSavedCities.compactMap { $0.rawValue }
            hideSearchBar = true
        }
    }
}

extension CitiesViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces).lowercased() else { return }
        searchResultCities = allCities.filter { $0.name.lowercased().contains(query) }
    }
}

extension CitiesViewModel {
    enum State: Int {
        case online = 0
        case offline = 1
    }
}
