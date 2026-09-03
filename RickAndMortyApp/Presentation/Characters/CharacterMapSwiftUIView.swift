//
//  CharacterMapSwiftUIView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/6/26.
//

import SwiftUI

struct CharacterMapSwiftUIView: View {

    let characters: [Character]

    var body: some View {

        ZStack {

            // MAPA UIKit
            MapViewRepresentable(characters: characters)
                .ignoresSafeArea()

            // UI SwiftUI encima
            VStack {

                Spacer()

                HStack(spacing: 20) {

                    Button {
                        // centrar
                    } label: {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    Button {
                        // cambiar tipo mapa
                    } label: {
                        Image(systemName: "map")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
    }
}
