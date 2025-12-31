//
//  MoviesListView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import SwiftUI

struct MoviesListView<ViewModel: MoviesListViewModelProtocols>: View {
    
    @StateObject private var viewModel: ViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            SearchBar(text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.onSearch(text: $0) }
            ))
            
            Text("Watch New Movies")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.yellow)
                .padding(.horizontal)
            
            GenreGridSectionView(viewModel: viewModel)
            
            if viewModel.movies.isEmpty {
                
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.movies.indices, id: \.self) { index in
                            let movie = viewModel.movies[index]
                            
                            MovieGridItemView(movie: movie)
                                .onAppear {
                                    if index == viewModel.movies.count - 1 {
                                        viewModel.loadNextPage()
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .gridCellColumns(2)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
