//
//  SearchAPI.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 03/05/26.
//

import Foundation

struct SearchResponse {
    let characters: [Character]
    let hasMorePages: Bool
}

struct SearchAPI: APIHandler {
    func parseResponse(data: Data) throws -> SearchResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(SearchResponseDTO.self, from: data)
        return response.buildResponse()
    }
}

private struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let origin: OriginDTO
    let type: String?
    let created: Date
    let image: URL?
}

private struct OriginDTO: Decodable {
    let name: String
}

private struct SearchResponseDTO: Decodable {
    let info: InfoDTO
    let results: [CharacterDTO]

    func buildResponse() -> SearchResponse {
        SearchResponse(
            characters: results.map { characterDTO in
                Character(
                    id: characterDTO.id,
                    name: characterDTO.name,
                    status: characterDTO.status,
                    species: characterDTO.species,
                    origin: characterDTO.origin.name,
                    type: characterDTO.type?.isEmpty == true ? nil : characterDTO.type,
                    createdAt: characterDTO.created,
                    imageURL: characterDTO.image
                )
            },
            hasMorePages: info.next != nil
        )
    }
}

private struct InfoDTO: Decodable {
    let next: URL?
}


