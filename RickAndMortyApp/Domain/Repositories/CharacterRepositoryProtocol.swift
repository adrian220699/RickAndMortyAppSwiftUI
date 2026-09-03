//
//  CharacterRepositoryProtocol.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/4/26.
//

import Foundation

protocol CharacterRepositoryProtocol {
    
    func getCharacters(
        page: Int,
        name: String?,
        status: String?,
        species: String?
    ) async throws -> [Character]
}
