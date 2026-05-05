//
//  CharacterListViewModel.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

@Observable
class CharacterListViewModel {
    private var searchTask: Task<Void, Never>?
    private let service: SearchService
    // TODO: Implement pagination later
    private let page = 1

    private(set) var characters: [Character] = []
    /*
     Acceptance criteria asked for a search after each keystroke.
     Ideally we would debounce it to wait until user finishes typing to avoid spamming the server
     */
    var searchText: String = "" {
        didSet {
            search()
        }
    }
    var isLoading: Bool = false

    init(service: SearchService = RickMortyService()) {
        self.service = service
    }

    func search() {
        searchTask?.cancel()

        guard !searchText.isEmpty else {
            characters = []
            isLoading = false
            return
        }

        isLoading = true

        searchTask = Task {
            let startTime = ContinuousClock.now

            do {
                let results = try await service.searchCharacter(searchTerm: searchText, page: page)
                guard !Task.isCancelled else { return }
                characters = results.characters
            } catch {
                if Task.isCancelled { return }
                characters = []
            }

            let elapsed = ContinuousClock.now - startTime
            if elapsed < Constants.minimumLoadingDuration {
                try? await Task.sleep(for: Constants.minimumLoadingDuration - elapsed)
            }
            guard !Task.isCancelled else { return }
            isLoading = false
        }
   }
}

private extension CharacterListViewModel {
    enum Constants {
        static let minimumLoadingDuration: Duration = .milliseconds(300)
    }
}
