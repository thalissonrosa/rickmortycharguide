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

    private let columns: [GridItem] = [
        GridItem(
            .adaptive(minimum: Dimensions.minimumItemWidth),
            spacing: Dimensions.defaultSpacing
        )
    ]

    var body: some View {
        NavigationStack {
            contentView
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

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.contentState {
        case .idle:
            ContentUnavailableView(.searchCTA, systemImage: "magnifyingglass")
        case .results(let characters):
            resultsView(characters: characters)
        case .empty:
            ContentUnavailableView.search
        case .error(let message):
            ContentUnavailableView {
                Label(L10n.errorTitle.localized, systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button(L10n.retry.localized) {
                    viewModel.search()
                }
            }
        }
    }

    private func resultsView(characters: [Character]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Dimensions.defaultSpacing) {
                ForEach(characters) { character in
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
