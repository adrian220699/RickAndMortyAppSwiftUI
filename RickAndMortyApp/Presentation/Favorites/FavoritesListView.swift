//
//  FavoritesListView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//
import SwiftUI
import UIKit

struct FavoritesListView: View {

    let characters: [Character]
    let onSelect: (Character) -> Void

    var body: some View {

        List(characters, id: \.id) { character in

            HStack {

                Group {

                    if let data = character.imageData,
                       let uiImage = UIImage(data: data) {

                        Image(uiImage: uiImage)
                            .resizable()

                    } else {

                        AsyncImage(url: URL(string: character.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                    }
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
