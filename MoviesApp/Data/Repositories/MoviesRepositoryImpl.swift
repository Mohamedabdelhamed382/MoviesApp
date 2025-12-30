//
//  MoviesRepositoryImpl.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

final class MoviesRepositoryImpl: MoviesRepository {
    
    // MARK: - Dependencies
    private let remoteDataSource: MoviesRemoteDataSource

    // MARK: - Init
    init(
        remoteDataSource: MoviesRemoteDataSource
    ) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Genres
    func fetchGenres() async throws -> [GenreEntity] {
        let dtos = try await remoteDataSource.fetchGenres()
        return dtos.map { $0.toDomain() }
    }
    
    // MARK: - Movies
    func fetchMoviesList(page: Int, genres: [Int]?) async throws -> MoviesPageEntity {
        let responseDTO = try await remoteDataSource.fetchMoviesList(page: page, genres: genres)
        return responseDTO.toDomain()
    }

    // MARK: - Movie Details
    func fetchMovieDetails(id: Int) async throws -> MovieDetailsEntity {
        let dto = try await remoteDataSource.fetchMovieDetails(id: id)
        return dto.toDomain()
    }
}
