//
//  MovieGridItemView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import SwiftUI

struct MovieGridItemView: View {
    let movie: MovieEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            posterView
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            titleAndYear
                .padding(4)
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
        )
    }
}

// MARK: - Subviews
private extension MovieGridItemView {

    var posterView: some View {
        CachedImageView(urlString: movie.posterPath) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
        }
    }

    var titleAndYear: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Text(movie.releaseYear)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
}
