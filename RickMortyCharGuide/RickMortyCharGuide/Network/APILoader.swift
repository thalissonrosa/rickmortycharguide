//
//  APILoader.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

typealias APIHandler = RequestHandler & ResponseHandler

class APILoader {
    private let urlSession: NetworkSession

    init(urlSession: NetworkSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    @MainActor
    func request<H: APIHandler>(router: Router, handler: H) async throws -> H.ResponseDataType {
        let urlRequest = try handler.makeRequest(from: router)
        let data = try await urlSession.loadData(with: urlRequest)
        do {
            return try handler.parseResponse(data: data)
        } catch {
            throw APIError.invalidData
        }
    }
}
