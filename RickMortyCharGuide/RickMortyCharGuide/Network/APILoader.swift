//
//  APILoader.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

typealias APIHandler = RequestHandler & ResponseHandler

struct APILoader {
    private let urlSession: NetworkSession

    init(urlSession: NetworkSession) {
        self.urlSession = urlSession
    }

    func request<H: APIHandler>(router: Router, handler: H) async throws -> H.ResponseDataType {
        let urlRequest = try handler.makeRequest(from: router)
        let (data, response) = try await urlSession.loadData(with: urlRequest)

        guard (200...299).contains(response.statusCode) else {
            throw APIError.httpError(statusCode: response.statusCode)
        }

        do {
            return try handler.parseResponse(data: data)
        } catch {
            throw APIError.invalidData
        }
    }
}
