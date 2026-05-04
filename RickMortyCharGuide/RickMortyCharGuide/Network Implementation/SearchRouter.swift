//
//  SearchRouter.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

enum SearchRouter: Router {
    case search(searchTerm: String, page: Int)

    var scheme: String {
        "https"
    }

    var host: String {
        "rickandmortyapi.com"
    }

    var path: String {
        switch self {
        case .search:
            return "/api/character"
        }
    }

    var method: String {
        "GET"
    }

    var headers: [String : String] {
        [:]
    }

    var parameters: [URLQueryItem] {
        switch self {
            case .search(let searchTerm, let page):
                return [
                    URLQueryItem(name: "name", value: searchTerm),
                    URLQueryItem(name: "page", value: String(page))
                ]
        }
    }
}
