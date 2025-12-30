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

    override func setUp() {
        super.setUp()
        cancellables = []

        // ⚡ Use real repository with real remoteDataSource
        let networkService = NetworkService()
        let remoteDataSource = MoviesRemoteDataSourceImpl(network: networkService)
        let repository = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
        useCase = FetchGenresUseCase(repository: repository)
    }

    override func tearDown() {
        cancellables = nil
        useCase = nil
        super.tearDown()
    }

    func testFetchGenresAPI() {
        let expectation = XCTestExpectation(description: "Genres fetched from API")

        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail("API request failed: \(error.localizedDescription)")
                    }
                },
                receiveValue: { genres in
                    print("Fetched Genres Count: \(genres.count)")
                    for genre in genres {
                        print("Genre ID: \(genre.id), Name: \(genre.name)")
                    }

                    XCTAssertFalse(genres.isEmpty, "Genres should not be empty")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}
