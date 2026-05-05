//
//  CharacterGridItemView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import SwiftUI

struct CharacterGridItemView: View {
    let character: Character
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            CharacterPictureView(url: character.imageURL)
                .frame(maxWidth: .infinity)
                .matchedTransitionSource(id: character.id, in: namespace)

            Text(character.name)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Text(character.species)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}
