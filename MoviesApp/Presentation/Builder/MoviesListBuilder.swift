//
//  MoviesListBuilder.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//


import SwiftUI

enum MoviesListBuilder {

    static func build() -> some View {

        // ⚡ Network
        let networkService = NetworkService()

        // ⚡ Remote Data Source
        let remoteDataSource = MoviesRemoteDataSourceImpl(
            network: networkService
        )

        // ⚡ Repository
        let repository = MoviesRepositoryImpl(
            remoteDataSource: remoteDataSource
        )

        // ⚡ UseCases
        let moviesUseCase = FetchMoviesUseCase(
            repository: repository
        )

        let genresUseCase = FetchGenresUseCase(
            repository: repository
        )

        // ⚡ ViewModel
        let viewModel = MoviesListViewModel(
            moviesUseCase: moviesUseCase,
            genresUseCase: genresUseCase
        )

        // ⚡ View (Dependency Inversion)
        return MoviesListView(viewModel: viewModel)
    }
}
