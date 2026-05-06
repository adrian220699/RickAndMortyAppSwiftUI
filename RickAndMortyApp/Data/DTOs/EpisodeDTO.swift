//
//  EpisodeDTO.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/4/26.
//

import Foundation

struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let episode: String
}
