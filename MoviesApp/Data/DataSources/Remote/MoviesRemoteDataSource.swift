//
//  MoviesRemoteDataSource.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

protocol MoviesRemoteDataSource {
    func fetchGenres() async throws -> [GenreDTO]
    func fetchMoviesList(page: Int, genres: [Int]?) async throws -> MoviesResponseDTO
    func fetchMovieDetails(id: Int) async throws -> MovieDetailsDTO
}

final class MoviesRemoteDataSourceImpl: MoviesRemoteDataSource {

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func fetchGenres() async throws -> [GenreDTO] {
        let response = try await network.request(
            APIEndpoints.genres(),
            type: GenresResponseDTO.self
        )
        return response.genres
    }
    
    func fetchMoviesList(page: Int, genres: [Int]?) async throws -> MoviesResponseDTO {
        let endpoint = APIEndpoints.moviesList(page: page, genres: genres)
        return try await network.request(endpoint, type: MoviesResponseDTO.self)
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetailsDTO {
        let endpoint = APIEndpoints.movieDetails(id: id)
        return try await network.request(endpoint, type: MovieDetailsDTO.self)
    }
}
