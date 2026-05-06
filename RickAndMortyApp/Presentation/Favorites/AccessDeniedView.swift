//
//  AccessDeniedView.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import SwiftUI

struct AccessDeniedView: View {
    var body: some View {
        VStack(spacing: 12) {

            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)

            Text("Acceso denegado")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}
