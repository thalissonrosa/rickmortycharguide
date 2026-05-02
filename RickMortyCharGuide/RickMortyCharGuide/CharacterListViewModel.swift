//
//  CharacterListViewModel.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

@Observable
class CharacterListViewModel {
    private let characters: [Character] = {
        var result: [Character] = []
        for _ in 0...20 {
            result.append(Character.buildMock())
        }
        return result
    }()

    var searchText: String = ""
    var filteredCharacters: [Character] {
        guard !searchText.isEmpty else {
            return characters
        }

        return characters.filter { character in
            character.name.localizedCaseInsensitiveContains(searchText)
        }
    }


}
