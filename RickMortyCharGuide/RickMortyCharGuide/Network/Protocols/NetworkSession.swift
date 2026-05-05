//
//  NetworkSession.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

protocol NetworkSession: Sendable {
    func loadData(with request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

