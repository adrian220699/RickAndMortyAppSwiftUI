//
//  Location.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/4/26.
//

import Foundation

struct Location {

    let name: String
    let latitude: Double
    let longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
