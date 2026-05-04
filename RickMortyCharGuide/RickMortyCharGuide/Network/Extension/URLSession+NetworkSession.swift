//
//  URLSession+NetworkSession.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

extension URLSession: NetworkSession {
    func loadData(with request: URLRequest) async throws -> Data {
        try await data(for: request).0
    }
}
