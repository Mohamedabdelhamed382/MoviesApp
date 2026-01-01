//
//  MovieDetailsBuilder.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 01/01/2026.
//

import SwiftUI

enum MovieDetailsBuilder {
    
    static func build(movieId: Int) -> some View {
        
        // ⚡ Network
        let networkService = NetworkService()
        
        // ⚡ Remote Data Source
        let remoteDataSource = MoviesRemoteDataSourceImpl(network: networkService)
        
        // ⚡ Repository
        let repository = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
        
        // ⚡ UseCases
        let useCase = FetchMovieDetailsUseCase(repository: repository)
        
        // ⚡ ViewModel
        let viewModel = MovieDetailsViewModel(movieId: movieId, useCase: useCase)
        
        // ⚡ View
        return MovieDetailsView(viewModel: viewModel)
        
    }
    
}
