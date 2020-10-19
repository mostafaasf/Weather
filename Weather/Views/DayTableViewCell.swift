//
//  DayTableViewCell.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet private weak var weatherCollectionView: UICollectionView!

    private var weatherViewModels: [WeatherViewModel] = []

    override func awakeFromNib() {
        weatherCollectionView.dataSource = self
    }

    func configure(weatherArray: [Weather]) {
        weatherViewModels = weatherArray.map { WeatherViewModel(weather: $0) }
        weatherCollectionView.reloadData()
    }
}

extension DayTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(viewModel: weatherViewModels[indexPath.row])
        return cell
    }


}
