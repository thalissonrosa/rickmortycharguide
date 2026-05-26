//
//  Text+L10n.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import SwiftUI

extension Text {
    init(_ key: L10n, _ args: CVarArg...) {
        self.init(key.formatted(args))
    }
}

enum L10n: String {
    case accessibilityHintViewDetails
    case accessibilityLabelLoading
    case accessibilityLabelPortrait
    case createdDate
    case errorMessage
    case errorTitle
    case origin
    case retry
    case searchCTA
    case searchPlaceholder
    case species
    case status
    case type
}

extension L10n {
    var localized: String {
        String(localized: String.LocalizationValue(rawValue))
    }

    func formatted(_ args: CVarArg...) -> String {
        formatted(args)
    }

    func formatted(_ args: [CVarArg]) -> String {
        String(format: localized, arguments: args)
    }
}
