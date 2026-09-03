//
//  EpisodeServiceProtocol.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import Foundation

protocol EpisodeServiceProtocol {
    func fetchEpisode(url: URL) async throws -> EpisodeDTO
}
