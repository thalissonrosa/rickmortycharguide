//
//  URLSession+NetworkSession.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

extension URLSession: NetworkSession {
    func loadData(with request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        for attempt in 0..<Constants.maxRetries {
            let (data, response) = try await data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            let isRetryable = httpResponse.statusCode == 429
                || (500...599).contains(httpResponse.statusCode)
            guard isRetryable else {
                return (data, httpResponse)
            }

            let delay = Constants.baseDelay * pow(2.0, Double(attempt))
            try await Task.sleep(for: .seconds(delay))
        }

        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        return (data, httpResponse)
    }
}

private enum Constants {
    static let maxRetries = 5
    static let baseDelay = 0.5
}
