//
//  CharacterDTO.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/4/26.
//

import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let location: LocationDTO
    let episode: [String]
}
