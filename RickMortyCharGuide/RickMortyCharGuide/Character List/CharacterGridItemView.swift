//
//  CharacterGridItemView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import SwiftUI

struct CharacterGridItemView: View {
    @State private var imageId = UUID()
    let character: Character

    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            AsyncImage(
                url: character.imageURL,
                transaction: Transaction(animation: .easeInOut)
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .transition(.opacity)
                case .failure:
                    failureView
                default:
                    loadingView
                }
            }
            .clipShape(.rect(cornerRadius: Constants.cornerRadius))
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .id(imageId)

            Text(character.name)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Text(character.species)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private var failureView: some View {
        Button {
            imageId = UUID()
        } label: {
            ZStack {
                Color(.systemGray5)
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }

    private var loadingView: some View {
        ZStack(alignment: .center) {
            Color(.lightGray)
            ProgressView()
        }
    }
}

private extension CharacterGridItemView {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
    }
}
