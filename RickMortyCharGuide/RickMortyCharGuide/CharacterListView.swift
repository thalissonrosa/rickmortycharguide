//
//  CharacterListView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import SwiftUI

struct CharacterListView: View {
    @State private var viewModel = CharacterListViewModel()
    private let colums: [GridItem] = [
        GridItem(
            .adaptive(minimum: Dimensions.minimumItemWidth),
            spacing: Dimensions.defaultSpacing
        )
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: colums, spacing: Dimensions.defaultSpacing) {
                        ForEach(viewModel.filteredCharacters) { character in
                            CharacterGridItemView(character: character)
                        }
                    }
                    .padding([.horizontal, .bottom], Dimensions.defaultSpacing)
                }
                .searchable(
                    text: $viewModel.searchText,
                    placement: .automatic,
                    prompt: .searchPlaceholder
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(.mainViewHeader)
            }
        }
    }
}

private extension CharacterListView {
    enum Dimensions {
        static let defaultSpacing: CGFloat = 16.0
        static let minimumItemWidth: CGFloat = 150.0

    }
}

#Preview {
    CharacterListView()
}
