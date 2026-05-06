//
//  FavoritesListView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import SwiftUI

struct FavoritesListView: View {

    let characters: [Character]
    let onSelect: (Character) -> Void

    var body: some View {
        List(characters, id: \.id) { character in
            HStack {

                AsyncImage(url: URL(string: character.image)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)

                    Text(character.species)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onSelect(character)
            }
        }
    }
}
