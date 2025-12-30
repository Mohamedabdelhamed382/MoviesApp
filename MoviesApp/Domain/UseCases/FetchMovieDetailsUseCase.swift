//
//  FetchMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

final class FetchMovieDetailsUseCase {

    private let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    func execute(movieId: Int) async throws -> MovieDetails {
            return try await repository.fetchMovieDetails(id: movieId)
    }
}
