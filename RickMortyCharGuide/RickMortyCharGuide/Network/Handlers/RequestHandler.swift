//
//  RequestHandler.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

protocol RequestHandler {
    func makeRequest(from router: Router) throws -> URLRequest
}

extension RequestHandler {
    func makeRequest(from router: Router) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        for header in router.headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }
}
