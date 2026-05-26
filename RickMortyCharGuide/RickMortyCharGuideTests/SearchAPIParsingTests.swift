//
//  SearchAPIParsingTests.swift
//  RickMortyCharGuideTests
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import Foundation
import Testing
@testable import RickMortyCharGuide

struct SearchAPIParsingTests {
    @Test func parsesValidJSON() throws {
        let json = """
        {
            "info": { "next": "https://rickandmortyapi.com/api/character?page=2&name=rick" },
            "results": [{
                "id": 1,
                "name": "Rick Sanchez",
                "status": "Alive",
                "species": "Human",
                "origin": { "name": "Earth (C-137)" },
                "type": "",
                "created": "2017-11-04T18:48:46.250Z",
                "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            }]
        }
        """.data(using: .utf8)!

        let response = try SearchAPI().parseResponse(data: json)

        #expect(response.characters.count == 1)
        #expect(response.hasMorePages == true)

        let character = response.characters[0]
        #expect(character.id == 1)
        #expect(character.name == "Rick Sanchez")
        #expect(character.status == "Alive")
        #expect(character.species == "Human")
        #expect(character.origin == "Earth (C-137)")
        #expect(character.type == nil)
        #expect(character.imageURL?.absoluteString == "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    }

    @Test func parsesNoNextPage() throws {
        let json = """
        {
            "info": { "next": null },
            "results": [{
                "id": 2,
                "name": "Morty Smith",
                "status": "Alive",
                "species": "Human",
                "origin": { "name": "unknown" },
                "type": null,
                "created": "2017-11-04T18:50:21.651Z",
                "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
            }]
        }
        """.data(using: .utf8)!

        let response = try SearchAPI().parseResponse(data: json)

        #expect(response.hasMorePages == false)
        #expect(response.characters[0].type == nil)
    }

    @Test func emptyTypeStringMapsToNil() throws {
        let json = """
        {
            "info": { "next": null },
            "results": [{
                "id": 3,
                "name": "Summer Smith",
                "status": "Alive",
                "species": "Human",
                "origin": { "name": "Earth" },
                "type": "",
                "created": "2017-11-04T19:09:56.428Z",
                "image": null
            }]
        }
        """.data(using: .utf8)!

        let response = try SearchAPI().parseResponse(data: json)

        #expect(response.characters[0].type == nil)
        #expect(response.characters[0].imageURL == nil)
    }
}
