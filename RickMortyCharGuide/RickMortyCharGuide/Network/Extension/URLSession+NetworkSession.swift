//
//  URLSession+NetworkSession.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

extension URLSession: NetworkSession {
    func loadData(with request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        return (data, httpResponse)
    }
}
