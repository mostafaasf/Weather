//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/16/20.
//

import UIKit
import Combine

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    private var cancellable: AnyCancellable?

    func configure(viewModel: WeatherViewModel) {
        cancellable = viewModel.$icon.receive(on: DispatchQueue.main).assign(to: \.image, on: iconImageView)
        temperatureLabel.text = viewModel.temperature
        timeLabel.text = viewModel.time
    }
}
