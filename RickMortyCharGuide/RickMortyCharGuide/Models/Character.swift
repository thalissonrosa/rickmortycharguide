//
//  Character.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

struct Character: Identifiable {
    let id: UUID
    let name: String
    let status: String
    let species: String
    let origin: String
    let type: String?
    let createdAt: Date
    let imageURL: URL?

    static func buildMock() -> Character {
        Bool.random() ? buildRick() : buildMorty()
    }
}

private extension Character {
    static func buildRick() -> Character {
        Character(
            id: UUID(),
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            origin: "Earth (C-137)",
            type: nil,
            createdAt: Date(),
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        )
    }

    static func buildMorty() -> Character {
        Character(
            id: UUID(),
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            origin: "unknown",
            type: nil,
            createdAt: Date(),
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
        )
    }
}
