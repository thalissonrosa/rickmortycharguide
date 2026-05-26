//
//  Router.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

protocol Router {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var parameters: [URLQueryItem] { get }
}
