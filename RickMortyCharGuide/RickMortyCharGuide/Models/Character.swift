//
//  Character.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

struct Character: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let origin: String
    let type: String?
    let createdAt: Date
    let imageURL: URL?
}
