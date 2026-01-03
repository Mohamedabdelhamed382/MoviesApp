//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

protocol MoviesRepository {
    // MARK: - Genres
    func fetchGenres() async throws -> [GenreEntity]
    
    // MARK: - Movies
    func fetchMoviesList(page: Int) async throws -> MoviesPageEntity

    // MARK: - Movie Details
    func fetchMovieDetails(id: Int) async throws -> MovieDetailsEntity
}
