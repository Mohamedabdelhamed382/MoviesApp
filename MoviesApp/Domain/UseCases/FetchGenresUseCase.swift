//
//  FetchGenresUseCase.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

final class FetchGenresUseCase {

    private let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Genre] {
        return try await repository.fetchGenres()
    }
}
