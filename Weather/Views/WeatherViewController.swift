//
//  ListViewController.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/15/20.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var dataSource: [[Weather]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Service.shared.getWeatherDataForCity(withID: 360630) { [weak self] weatherArray in

            // Group by date
            let groupedDictionary = Dictionary(grouping: weatherArray, by: {
                DateFormatter.localizedString(from: $0.date, dateStyle: .long, timeStyle: .none)
            })

            // Convert back to array and sort
            self?.dataSource = Array(groupedDictionary.values).sorted { $0[0].date < $1[0].date }

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DateFormatter.localizedString(
            from: dataSource[section][0].date,
            dateStyle: .long,
            timeStyle: .none
        )
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
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
