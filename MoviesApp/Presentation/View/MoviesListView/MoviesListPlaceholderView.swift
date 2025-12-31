//
//  MoviesListPlaceholderView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import SwiftUI

struct MoviesListPlaceholderView<ViewModel: MoviesListViewModelProtocols>: View {
    
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        if viewModel.movies.isEmpty {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
