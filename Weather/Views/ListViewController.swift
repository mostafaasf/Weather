//
//  ListViewController.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/15/20.
//

import UIKit
import Combine

class ListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var sectionHeaders: [String] = []
    private var dataSource: [[Weather]] = []
    private var cancellables = Set<AnyCancellable>()

    var viewModel: ListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel?.cityName

        // Bind values
        viewModel?.$sectionHeaders.assign(to: \.sectionHeaders, on: self).store(in: &cancellables)
        viewModel?.$dataSource.assign(to: \.dataSource, on: self).store(in: &cancellables)

        // Bind reload function
        viewModel?.$reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? DayTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(weatherArray: dataSource[indexPath.section])
        return cell
    }
}
