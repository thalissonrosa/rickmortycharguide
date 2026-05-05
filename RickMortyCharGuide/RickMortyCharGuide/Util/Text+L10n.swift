//
//  Text+L10n.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import SwiftUI

extension Text {
    init(_ key: L10n, _ args: CVarArg...) {
        self.init(String(format: key.localized, arguments: args))
    }
}

enum L10n: String {
    case createdDate
    case errorMessage
    case errorTitle
    case origin
    case retry
    case species
    case status
    case type
}

extension L10n {
    var localized: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}
