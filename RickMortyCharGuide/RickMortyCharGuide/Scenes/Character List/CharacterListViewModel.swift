//
//  CharacterListViewModel.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

@MainActor
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
    private var currentPage = 1
    private var hasMorePages = false

    private(set) var contentState: ContentState = .idle
    private(set) var isLoadingMore = false
    private(set) var scrollID = 0
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

    init(service: SearchService) {
        self.service = service
    }

    convenience init() {
        self.init(service: RickMortyService())
    }

    func search() {
        searchTask?.cancel()
        currentPage = 1
        hasMorePages = false
        scrollID += 1

        guard !searchText.isEmpty else {
            contentState = .idle
            isLoading = false
            return
        }

        isLoading = true

        searchTask = Task {
            let startTime = ContinuousClock.now

            do {
                let characters = try await fetchCharacters(page: currentPage)
                contentState = characters.isEmpty ? .empty : .results(characters)
            } catch is CancellationError {
                return
            } catch {
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

    func loadNextPage() {
        guard hasMorePages, !isLoading, !isLoadingMore else { return }

        isLoadingMore = true
        currentPage += 1

        searchTask = Task {
            do {
                let characters = try await fetchCharacters(page: currentPage)
                if case .results(let existing) = contentState {
                    contentState = .results(existing + characters)
                }
            } catch is CancellationError {
                return
            } catch {
                currentPage -= 1
            }

            isLoadingMore = false
        }
    }

    private func fetchCharacters(page: Int) async throws -> [Character] {
        let results = try await service.searchCharacter(searchTerm: searchText, page: page)
        guard !Task.isCancelled else {
            throw CancellationError()
        }
        hasMorePages = results.hasMorePages
        return results.characters
    }
}

private extension CharacterListViewModel {
    enum Constants {
        static let minimumLoadingDuration: Duration = .milliseconds(300)
    }
}
