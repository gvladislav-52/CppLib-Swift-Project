//
//  RickAndMortyView.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import SwiftUI

struct RickAndMortyView: View {

    @StateObject private var viewModel = RickAndMortyViewModel()

    var body: some View {
        VStack(spacing: 20) {

            if !viewModel.characters.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.characters) { character in
                            CharacterRow(character: character)
                        }
                    }
                }
            }

            Button("Load Rick & Morty Characters") {
                viewModel.fetchCharacters()
            }
            .padding(.top)
        }
        .padding()
    }
}

struct CharacterRow: View {
    let character: RickAndMortyModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            if let url = URL(string: character.imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name).font(.headline)
                Text("Species: \(character.species)")
                Text("Status: \(character.status)")
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}
