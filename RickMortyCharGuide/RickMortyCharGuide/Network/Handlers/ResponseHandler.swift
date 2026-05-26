//
//  ResponseHandler.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 02/05/26.
//

import Foundation

protocol ResponseHandler {
    associatedtype ResponseDataType
    func parseResponse(data: Data) throws -> ResponseDataType
}
