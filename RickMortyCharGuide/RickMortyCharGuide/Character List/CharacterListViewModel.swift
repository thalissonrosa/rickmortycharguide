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
        let startTime = Date()

        searchTask = Task {
            defer {
                /*
                 Usually it would be just setting isLoading = false, but API is too fast and you can't even see the loading
                 To make it easier to verify the loading indicator, a minimum delay of 0.4 seconds is being forced.
                 */
                Task {
                    let elapsed = Date().timeIntervalSince(startTime)
                    let minimumDelay = 0.4

                    if elapsed < minimumDelay {
                        try? await Task.sleep(for: .seconds(minimumDelay - elapsed))
                    }

                    isLoading = false
                }
            }

            do {
                let results = try await service.searchCharacter(searchTerm: searchText, page: page)

                guard !Task.isCancelled else { return }
                characters = results.characters
            } catch {
                if Task.isCancelled { return }
                characters = []
            }
        }
   }
}
