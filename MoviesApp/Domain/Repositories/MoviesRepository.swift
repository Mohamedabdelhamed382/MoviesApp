//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

protocol MoviesRepository {
    // MARK: - Genres
    func fetchGenres() async throws -> [Genre]
    
    // MARK: - Movies
    func fetchMoviesList(page: Int, genres: [Int]?) async throws -> MoviesPage
}

final class MoviesRepositoryImpl: MoviesRepository {
    
    // MARK: - Dependencies
    private let remoteDataSource: MoviesRemoteDataSource

    // MARK: - Init
    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Genres
    func fetchGenres() async throws -> [Genre] {
        let dtos = try await remoteDataSource.fetchGenres()
        return dtos.map { $0.toDomain() }
    }
    
    // MARK: - Movies
    func fetchMoviesList(page: Int, genres: [Int]?) async throws -> MoviesPage {
        let responseDTO = try await remoteDataSource.fetchMoviesList(page: page, genres: genres)
        return responseDTO.toDomain()
    }
}

