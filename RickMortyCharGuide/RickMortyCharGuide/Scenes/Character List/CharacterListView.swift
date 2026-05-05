//
//  CharacterListView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import SwiftUI

struct CharacterListView: View {
    @Namespace private var namespace
    @State private var viewModel = CharacterListViewModel()

    private let colums: [GridItem] = [
        GridItem(
            .adaptive(minimum: Dimensions.minimumItemWidth),
            spacing: Dimensions.defaultSpacing
        )
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.characters.isEmpty {
                    emptyView
                } else {
                    contentView
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()

                        ProgressView()
                            .controlSize(.large)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: .searchPlaceholder
            )
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(character: character)
                    .navigationTransition(.zoom(sourceID: character.id, in: namespace))
            }
        }
    }

    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: colums, spacing: Dimensions.defaultSpacing) {
                ForEach(viewModel.characters) { character in
                    NavigationLink(value: character) {
                        // Items might have different heights, we need to push everything to align it to the top
                        VStack(spacing: 0) {
                            CharacterGridItemView(character: character, namespace: namespace)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .bottom], Dimensions.defaultSpacing)
        }
    }

    @ViewBuilder
    private var emptyView: some View {
        if viewModel.searchText.isEmpty {
            ContentUnavailableView(.searchCTA, systemImage: "magnifyingglass")
        } else {
            ContentUnavailableView.search
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
