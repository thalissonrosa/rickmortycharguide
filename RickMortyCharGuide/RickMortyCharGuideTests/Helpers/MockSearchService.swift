//
//  MockSearchService.swift
//  RickMortyCharGuideTests
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import Foundation
@testable import RickMortyCharGuide

final class MockSearchService: SearchService {
    var result: Result<SearchResponse, Error> = .success(SearchResponse(characters: [], hasMorePages: false))
    var delay: Duration = .zero
    var handler: ((String, Int) async throws -> SearchResponse)?
    private(set) var calls: [(searchTerm: String, page: Int)] = []

    func searchCharacter(searchTerm: String, page: Int) async throws -> SearchResponse {
        calls.append((searchTerm, page))
        if delay > .zero {
            try await Task.sleep(for: delay)
        }
        if let handler {
            return try await handler(searchTerm, page)
        }
        return try result.get()
    }
}
