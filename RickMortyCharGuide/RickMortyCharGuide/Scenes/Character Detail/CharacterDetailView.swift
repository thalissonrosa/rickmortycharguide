//
//  CharacterDetailView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        VStack(alignment: .center, spacing: Dimensions.bodySpacing) {
            imageHeader
            textBody
            Spacer()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.automatic)
    }

    private var imageHeader: some View {
        VStack {
            CharacterPictureView(url: character.imageURL)
                .frame(maxWidth: .infinity)
                .clipped()
        }
        .padding()
        .accessibilityLabel(L10n.accessibilityLabelPortrait.formatted(character.name))
    }

    private var textBody: some View {
        VStack(spacing: Dimensions.textSpacing) {
            Text(.species, character.species)
            Text(.status, character.status)
            Text(.origin, character.origin)
            if let type = character.type {
                Text(.type, type)
            }
            Text(.createdDate, character.createdAt.formatted(date: .long, time: .omitted))
        }
    }
}

private extension CharacterDetailView {
    enum Dimensions {
        static let textSpacing: CGFloat = 4.0
        static let bodySpacing: CGFloat = 8.0
    }
}
