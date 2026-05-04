//
//  NetworkSession.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

protocol NetworkSession {
    func loadData(with request: URLRequest) async throws -> Data
}

