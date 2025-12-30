//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

protocol MoviesRepository {

    // MARK: - Genres
    func fetchGenres() -> AnyPublisher<[Genre], AppError>

}

final class MoviesRepositoryImpl: MoviesRepository {

    // MARK: - Dependencies
    private let remoteDataSource: MoviesRemoteDataSource

    // MARK: - Init
    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Genres
    func fetchGenres() -> AnyPublisher<[Genre], AppError> {
        remoteDataSource.fetchGenres()
            .map { dtoList in
                dtoList.map { $0.toDomain() }
            }
            .mapError { AppError.api($0) }
            .eraseToAnyPublisher()
    }

}
