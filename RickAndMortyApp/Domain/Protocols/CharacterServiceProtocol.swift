//
//  CharacterServiceProtocol.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

protocol CharacterServiceProtocol {
    func fetchCharacters(
        page: Int,
        name: String?,
        status: String?,
        species: String?
    ) async throws -> CharacterResponseDTO
}
