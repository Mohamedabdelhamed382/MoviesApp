//
//  SimpleGenreTag.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import SwiftUI

struct GenreGridSectionView<ViewModel: MoviesListViewModelProtocols>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.genres, id: \.id) { genre in
                    GenreTag(
                        genre: genre.name,
                        isSelected: viewModel.selectedGenres.contains(genre),
                        action: {
                            viewModel.toggleGenre(genre)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GenreTag: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .black : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.yellow : Color(.systemGray5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 1)
                )
        }
        .fixedSize()
    }
}
