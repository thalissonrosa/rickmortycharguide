//
//  CharacterPictureView.swift
//  RickMortyCharGuide
//
//  Created by Thalisson da Rosa on 04/05/26.
//

import NukeUI
import SwiftUI

struct CharacterPictureView: View {
    @State private var retryCount = 0
    let url: URL?
    private var retryURL: URL? {
        url?.appending(queryItems: [
            URLQueryItem(name: "retry", value: "\(retryCount)")
        ])
    }

    var body: some View {
        LazyImage(url: retryURL) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if state.error != nil {
                failureView
            } else {
                loadingView
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
    }

    private var failureView: some View {
        Button {
            retryCount += 1
        } label: {
            ZStack {
                Color(.systemGray5)
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }

    private var loadingView: some View {
        ZStack(alignment: .center) {
            Color(.lightGray)
            ProgressView()
        }
    }
}

private extension CharacterPictureView {
    enum Constants {
        static let cornerRadius: CGFloat = 8.0
    }
}
