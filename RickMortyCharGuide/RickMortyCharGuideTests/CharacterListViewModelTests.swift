//
//  CharacterListViewModelTests.swift
//  RickMortyCharGuideTests
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import Foundation
import Testing
@testable import RickMortyCharGuide

@MainActor
struct CharacterListViewModelTests {
    private func makeCharacter(id: Int = 1, name: String = "Rick") -> Character {
        Character(
            id: id,
            name: name,
            status: "Alive",
            species: "Human",
            origin: "Earth",
            type: nil,
            createdAt: .now,
            imageURL: nil
        )
    }

    @Test func searchWithResultsSetsResultsState() async throws {
        let character = makeCharacter()
        let mock = MockSearchService()
        mock.handler = { searchTerm, page in
            #expect(searchTerm == "Rick")
            #expect(page == 1)
            return SearchResponse(characters: [character], hasMorePages: false)
        }

        let viewModel = CharacterListViewModel(service: mock)
        viewModel.searchText = "Rick"

        try await Task.sleep(for: .milliseconds(400))

        guard case .results(let characters) = viewModel.contentState else {
            Issue.record("Expected .results state")
            return
        }
        #expect(characters.count == 1)
        #expect(characters[0].name == "Rick")
        #expect(viewModel.isLoading == false)
        #expect(mock.calls.count == 1)
    }

    @Test func emptySearchResetsToIdle() async {
        let mock = MockSearchService()
        mock.result = .success(SearchResponse(characters: [makeCharacter()], hasMorePages: false))

        let viewModel = CharacterListViewModel(service: mock)
        viewModel.searchText = "Rick"

        try? await Task.sleep(for: .milliseconds(400))

        viewModel.searchText = ""

        guard case .idle = viewModel.contentState else {
            Issue.record("Expected .idle state")
            return
        }
        #expect(viewModel.isLoading == false)
        #expect(mock.calls.count == 1)
        #expect(mock.calls[0].searchTerm == "Rick")
    }

    @Test func emptyResultsSetsEmptyState() async throws {
        let mock = MockSearchService()
        mock.handler = { searchTerm, _ in
            #expect(searchTerm == "zzzzz")
            return SearchResponse(characters: [], hasMorePages: false)
        }

        let viewModel = CharacterListViewModel(service: mock)
        viewModel.searchText = "zzzzz"

        try await Task.sleep(for: .milliseconds(400))

        guard case .empty = viewModel.contentState else {
            Issue.record("Expected .empty state")
            return
        }
        #expect(mock.calls.count == 1)
    }

    @Test func errorSetsErrorState() async throws {
        let mock = MockSearchService()
        mock.result = .failure(APIError.httpError(statusCode: 500))

        let viewModel = CharacterListViewModel(service: mock)
        viewModel.searchText = "Rick"

        try await Task.sleep(for: .milliseconds(400))

        guard case .error = viewModel.contentState else {
            Issue.record("Expected .error state")
            return
        }
        #expect(viewModel.isLoading == false)
    }

    @Test func rapidSearchesCancelsPreviousAndKeepsLastResult() async throws {
        let mock = MockSearchService()
        mock.delay = .milliseconds(100)
        mock.handler = { searchTerm, _ in
            SearchResponse(
                characters: [Character(
                    id: 1,
                    name: "Result for \(searchTerm)",
                    status: "Alive",
                    species: "Human",
                    origin: "Earth",
                    type: nil,
                    createdAt: .now,
                    imageURL: nil
                )],
                hasMorePages: false
            )
        }

        let viewModel = CharacterListViewModel(service: mock)

        viewModel.searchText = "Ri"
        viewModel.searchText = "Ric"
        viewModel.searchText = "Rick"

        try await Task.sleep(for: .milliseconds(600))

        guard case .results(let characters) = viewModel.contentState else {
            Issue.record("Expected .results state")
            return
        }
        #expect(characters.count == 1)
        #expect(characters[0].name == "Result for Rick")
    }

    @Test func newSearchResetsScrollID() async {
        let mock = MockSearchService()
        let viewModel = CharacterListViewModel(service: mock)

        let initialScrollID = viewModel.scrollID
        viewModel.searchText = "Rick"

        #expect(viewModel.scrollID > initialScrollID)
    }
}
