//
//  FetchGenresUseCaseAPITests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import XCTest
import Combine
@testable import MoviesApp

final class FetchGenresUseCaseAPITests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var useCase: FetchGenresUseCase!

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
        useCase = FetchGenresUseCase(repository: repository)
    }

    override func tearDown() {
        cancellables = nil
        useCase = nil
        super.tearDown()
    }

    @MainActor
    func testFetchGenresAPI() async throws {
        // Use async/await since useCase.execute() is async
        let genres = try await useCase.execute()

        print("Fetched Genres Count: \(genres.count)")
        for genre in genres {
            print("Genre ID: \(genre.id), Name: \(genre.name)")
        }

        XCTAssertFalse(genres.isEmpty, "Genres should not be empty")
    }
}
