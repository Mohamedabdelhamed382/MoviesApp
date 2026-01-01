//
//  MoviesListPlaceholderView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import SwiftUI

struct MoviesListPlaceholderView: View {

    let isLoading: Bool

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                emptyState
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.7))

            Text("No movies found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)

            Text("Try adjusting your search or filters.")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
