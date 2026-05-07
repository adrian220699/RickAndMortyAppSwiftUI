//
//  EpisodeRowView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import SwiftUI

struct EpisodeRowView: View {

    let episode: Episode
    let onTap: () -> Void

    var body: some View {

        Button(action: onTap) {

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text(episode.name)
                        .font(.headline)

                    Text(episode.episodeCode)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if episode.isWatched {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                episode.isWatched
                ? Color.green.opacity(0.1)
                : Color.clear
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}
