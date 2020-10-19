//
//  City.swift
//  Weather
//
//  Created by Mostafa Shawky on 10/15/20.
//

import Foundation

class City: Codable {
    let id: Int
    let name: String
    let country: String

    var fullName: String {
        return "\(name), \(country)"
    }
}
