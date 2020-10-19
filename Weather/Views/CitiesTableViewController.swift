//
//  CitiesTableViewController.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import UIKit
import Combine

class CitiesTableViewController: UITableViewController {

    private let viewModel = CitiesViewModel()
    private var searchResults: [String] = []
    private var searchController: UISearchController!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = viewModel
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        viewModel.$hideSearchBar
            .receive(on: DispatchQueue.main)
            .assign(to: \.searchController.searchBar.isHidden, on: self)
            .store(in: &cancellables)

        viewModel.$searchResults.receive(on: DispatchQueue.main).sink { [weak self] results in
            self?.searchResults = results
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$isDone.receive(on: DispatchQueue.main).sink { [weak self] isDone in
            self?.searchController.searchBar.placeholder = isDone ? "Type a city's name ..." : "Loading ..."
            self?.searchController.searchBar.isUserInteractionEnabled = isDone
        }.store(in: &cancellables)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listViewController = storyboard?.instantiateViewController(withIdentifier: "weather") as? ListViewController else {
            return
        }
        listViewController.viewModel = viewModel.listViewModel(for: indexPath)
        navigationController?.pushViewController(listViewController, animated: true)
    }

    @IBAction private func segmentedControlAction(_ sender: UISegmentedControl) {
        viewModel.didChangeSegmentedControlTo(value: sender.selectedSegmentIndex)
    }

}
