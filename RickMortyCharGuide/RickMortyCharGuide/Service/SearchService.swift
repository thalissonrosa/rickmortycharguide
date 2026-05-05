//
//  SearchService.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 03/05/26.
//

import Foundation

struct SearchResponse {
    let characters: [Character]
    let hasMorePages: Bool
}

protocol SearchService {
    func searchCharacter(searchTerm: String, page: Int) async throws -> SearchResponse
}

struct RickMortyService: SearchService {
    private let networkLoader: APILoader

    init(networkLoader: APILoader = APILoader(urlSession: URLSession.shared)) {
        self.networkLoader = networkLoader
    }

    func searchCharacter(searchTerm: String, page: Int) async throws -> SearchResponse {
        do {
            return try await networkLoader.request(
                router: SearchRouter.search(searchTerm: searchTerm, page: page),
                handler: SearchAPI()
            )
        } catch APIError.httpError(statusCode: 404) {
            return SearchResponse(characters: [], hasMorePages: false)
        }
    }
}
