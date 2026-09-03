//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//
import Foundation
import Combine

final class CharacterDetailViewModel: ObservableObject {

    private let character: Character
    private let repository: FavoritesRepositoryProtocol
    private let episodeService: EpisodeServiceProtocol
    private let storage = StorageManager.shared

    @Published var episodes: [Episode] = []
    @Published private(set) var isFavoriteState: Bool = false

    init(
        character: Character,
        repository: FavoritesRepositoryProtocol,
        episodeService: EpisodeServiceProtocol
    ) {
        self.character = character
        self.repository = repository
        self.episodeService = episodeService

        self.isFavoriteState = repository.isFavorite(id: character.id)
    }

    var characterData: Character { character }
    var id: Int { character.id }
    var name: String { character.name }
    var species: String { character.species }

    var status: String {
        switch character.status {
        case .alive: return "Alive"
        case .dead: return "Dead"
        case .unknown: return "Unknown"
        }
    }

    var gender: String { character.gender }
    var location: String { character.location?.name ?? "Unknown" }
    var imageURL: String { character.image }
    var episodeURLs: [String] { character.episodeURLs }

    // MARK: FAVORITE (REACTIVO + PERSISTENTE)
    var isFavorite: Bool {
        isFavoriteState
    }

    func toggleFavorite() {
        if repository.isFavorite(id: character.id) {
            repository.deleteFavorite(id: character.id)
            isFavoriteState = false
        } else {
            repository.saveFavorite(character)
            isFavoriteState = true
        }
    }

    // MARK: EPISODES
    func fetchEpisodes() async {

        var temp: [Episode] = []

        let watched = storage.getWatchedEpisodes(characterId: character.id)

        await withTaskGroup(of: EpisodeDTO?.self) { group in

            for urlString in episodeURLs {
                group.addTask {
                    guard let url = URL(string: urlString) else { return nil }
                    return try? await self.episodeService.fetchEpisode(url: url)
                }
            }

            for await dto in group {
                if let dto {
                    temp.append(
                        Episode(
                            id: dto.id,
                            name: dto.name,
                            episodeCode: dto.episode,
                            isWatched: watched.contains(dto.id)
                        )
                    )
                }
            }
        }

        await MainActor.run {
            self.episodes = temp.sorted { $0.id < $1.id }
        }
    }

    // MARK: TOGGLE EPISODE (CORE DATA REAL)
    func toggleWatched(at index: Int) {
        guard episodes.indices.contains(index) else { return }

        let episode = episodes[index]

        storage.toggleEpisodeWatched(
            characterId: character.id,
            episodeId: episode.id
        )

        episodes[index].isWatched = storage.isEpisodeWatched(
            characterId: character.id,
            episodeId: episode.id
        )
    }
}
