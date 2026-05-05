//
//  CharacterListViewModel.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

@Observable
class CharacterListViewModel {
    enum ContentState {
        case idle
        case results([Character])
        case empty
        case error(String)
    }

    private var searchTask: Task<Void, Never>?
    private let service: SearchService
    // TODO: Implement pagination later
    private let page = 1

    private(set) var contentState: ContentState = .idle
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
            contentState = .idle
            isLoading = false
            return
        }

        isLoading = true

        searchTask = Task {
            let startTime = ContinuousClock.now

            do {
                let results = try await service.searchCharacter(searchTerm: searchText, page: page)
                guard !Task.isCancelled else { return }
                contentState = results.characters.isEmpty ? .empty : .results(results.characters)
            } catch {
                if Task.isCancelled { return }
                contentState = .error(L10n.errorMessage.localized)
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
