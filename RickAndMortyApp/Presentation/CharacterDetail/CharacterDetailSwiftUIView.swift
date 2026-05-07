//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import SwiftUI

struct CharacterDetailSwiftUIView: View {

    @ObservedObject var viewModel: CharacterDetailViewModel

    let onToggleFavorite: () -> Void
    let onToggleEpisode: (Int) -> Void
    let onOpenMap: () -> Void

    var body: some View {

        List {

            // MARK: HEADER
            VStack(alignment: .leading, spacing: 12) {

                AsyncImage(url: URL(string: viewModel.imageURL)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(viewModel.name)
                    .font(.title)
                    .bold()

                Text("Species: \(viewModel.species)")
                Text("Status: \(viewModel.status)")
                Text("Gender: \(viewModel.gender)")
                Text("Location: \(viewModel.location)")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .listRowSeparator(.hidden)

            // MARK: ACTIONS (FAVORITO + MAPA CENTRADOS)
            Section {

                HStack {

                    Spacer()

                    // FAVORITO
                    Button {
                        onToggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                            .padding(12)
                    }
                    .buttonStyle(.plain)

                    // MAPA (CORRECTO)
                    Button {
                        onOpenMap()
                    } label: {
                        Image(systemName: "map")   // 👈 correcto SF Symbol
                            .font(.system(size: 26))
                            .foregroundColor(.blue)
                            .padding(12)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .listRowSeparator(.hidden)
            }

            // MARK: EPISODES (SIN TEXTO "Episodes")
            Section {

                ForEach(Array(viewModel.episodes.enumerated()), id: \.offset) { index, episode in

                    EpisodeRowView(
                        episode: episode,
                        onTap: {
                            onToggleEpisode(index)
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(viewModel.name)
    }
}
