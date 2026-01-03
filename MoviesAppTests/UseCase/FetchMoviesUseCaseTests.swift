//
//  FetchMoviesUseCaseTests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import XCTest
import Combine
@testable import MoviesApp

final class FetchMoviesUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    private var useCase: FetchMoviesUseCase!

    @MainActor
    override func setUp() {
        super.setUp()
        cancellables = []

        // ⚡ Use real repository with real remoteDataSource
        let networkService = NetworkService()
        let remoteDataSource = MoviesRemoteDataSourceImpl(network: networkService)
        let localDataSource = MoviesLocalDataSourceImpl()
        let repository = MoviesRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        useCase = FetchMoviesUseCase(repository: repository)
    }

    override func tearDown() {
        cancellables = nil
        useCase = nil
        super.tearDown()
    }

    @MainActor
    func testFetchMoviesAPI() async throws {
        
        let movies = try await useCase.execute(page: 1)

        print("Fetched movies Count: \(movies.movies.count)")
        for movie in movies.movies {
            print("Genre ID: \(movie.id), Name: \(movie.title)")
        }
        
        XCTAssertFalse(movies.movies.isEmpty, "movies should not be empty")
    }
}
