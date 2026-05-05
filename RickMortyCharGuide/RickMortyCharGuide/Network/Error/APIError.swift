//
//  APIError.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

enum APIError: Error {
    case invalidURL
    case noData
    case invalidData
    case invalidResponse
    case httpError(statusCode: Int)
}
