//
//  FetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

final class FetchMoviesUseCase {
    
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> MoviesPageEntity {
        return try await repository.fetchMoviesList(page: page)
    }
}
