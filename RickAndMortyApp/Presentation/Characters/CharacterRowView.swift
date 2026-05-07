//
//  CharacterRowView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import SwiftUI

struct CharacterRowView: View {

    let character: Character

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {

                Text(character.name)
                    .font(.headline)

                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(character.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding(.vertical, 10)
    }
}
