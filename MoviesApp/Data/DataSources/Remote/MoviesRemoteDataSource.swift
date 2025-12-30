//
//  MoviesRemoteDataSource.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

protocol MoviesRemoteDataSource {
    func fetchGenres() -> AnyPublisher<[GenreDTO], APIError>
}

final class MoviesRemoteDataSourceImpl: MoviesRemoteDataSource {

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func fetchGenres() -> AnyPublisher<[GenreDTO], APIError> {
        network.request(
            APIEndpoints.genres(),
            type: GenresResponseDTO.self
        )
        .map(\.genres)
        .eraseToAnyPublisher()
    }
}
