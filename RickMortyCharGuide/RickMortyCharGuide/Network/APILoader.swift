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

    func request<H: APIHandler>(router: Router, handler: H, maxRetries: Int = 0) async throws -> H.ResponseDataType {
        let urlRequest = try handler.makeRequest(from: router)

        for attempt in 0..<maxRetries {
            let (data, response) = try await urlSession.loadData(with: urlRequest)

            let isRetryable = response.statusCode == 429
                || (500...599).contains(response.statusCode)
            guard isRetryable else {
                return try parseSuccessResponse(data: data, statusCode: response.statusCode, handler: handler)
            }

            try Task.checkCancellation()
            let delay = Constants.baseDelay * pow(2.0, Double(attempt))
            try await Task.sleep(for: .seconds(delay))
        }

        let (data, response) = try await urlSession.loadData(with: urlRequest)
        return try parseSuccessResponse(data: data, statusCode: response.statusCode, handler: handler)
    }

    private func parseSuccessResponse<H: APIHandler>(data: Data, statusCode: Int, handler: H) throws -> H.ResponseDataType {
        guard (200...299).contains(statusCode) else {
            throw APIError.httpError(statusCode: statusCode)
        }

        do {
            return try handler.parseResponse(data: data)
        } catch {
            throw APIError.invalidData
        }
    }
}

private enum Constants {
    static let baseDelay = 0.5
}
