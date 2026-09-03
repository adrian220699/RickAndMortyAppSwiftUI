//
//  EpisodeService.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/4/26.
//

import Foundation

final class EpisodeService: EpisodeServiceProtocol {

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchEpisode(url: URL) async throws -> EpisodeDTO {
        return try await networkManager.request(url: url)
    }
}
