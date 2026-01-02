//
//  FetchMovieDetailsUseCaseAPITests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//


//
//  FetchMovieDetailsUseCaseAPITests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import XCTest
import Combine
@testable import MoviesApp

final class FetchMovieDetailsUseCaseAPITests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var useCase: FetchMovieDetailsUseCase!

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
        useCase = FetchMovieDetailsUseCase(repository: repository)
    }

    override func tearDown() {
        cancellables = nil
        useCase = nil
        super.tearDown()
    }

    @MainActor
    func testFetchMovieDetailsAPI() async throws {
        // Arrange: Replace 550 with any valid movie ID
        let movieId = 1511417

        // Act
        let movieDetails = try await useCase.execute(movieId: movieId)

        // Debug prints
        print("Movie ID: \(movieDetails.id)")
        print("Title: \(movieDetails.title)")
        print("Release Year-Month: \(movieDetails.releaseYearMonth ?? "N/A")")
        print("Genres: \(movieDetails.genres.map { $0.name }.joined(separator: ", "))")
        print("Homepage: \(movieDetails.homepage ?? "N/A")")
        print("Budget: \(movieDetails.budget ?? 0)")
        print("Revenue: \(movieDetails.revenue ?? 0)")
        print("Spoken Languages: \(movieDetails.spokenLanguages.joined(separator: ", "))")
        print("Runtime: \(movieDetails.runtime ?? 0) minutes")
        print("Status: \(movieDetails.status ?? "N/A")")

        // Assert
        XCTAssertEqual(movieDetails.id, movieId)
        XCTAssertFalse(movieDetails.title.isEmpty, "Movie title should not be empty")
        XCTAssertFalse(movieDetails.genres.isEmpty, "Movie should have at least one genre")
    }
}
