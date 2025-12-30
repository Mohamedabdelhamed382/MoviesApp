//
//  FetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

final class FetchMoviesUseCase {
    
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute(page: Int, genres: [Int]? = nil) async throws -> MoviesPage {
        return try await repository.fetchMoviesList(page: page, genres: genres)
    }
}
