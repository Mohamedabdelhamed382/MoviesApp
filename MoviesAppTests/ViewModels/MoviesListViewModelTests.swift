//
//  MoviesListViewModelTests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 01/01/2026.
//


import XCTest
import Combine
@testable import MoviesApp

final class MoviesListViewModelTests: XCTestCase {
    
    private var viewModel: MoviesListViewModel!
    private var mockRepository: MockMoviesRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockMoviesRepository()
        let moviesUseCase = FetchMoviesUseCase(repository: mockRepository)
        let genresUseCase = FetchGenresUseCase(repository: mockRepository)
        viewModel = MoviesListViewModel(moviesUseCase: moviesUseCase, genresUseCase: genresUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    @MainActor
    func test_onAppear_loadsMoviesAndGenres() async {
        // Given
        mockRepository.moviesResult = MoviesPageEntity(
            page: 1,
            movies: [MovieEntity.mock()],
            totalPages: 1,
            totalResults: 1
        )
        mockRepository.genresResult = [GenreEntity.mock()]
        
        // When
        viewModel.onAppear()
        
        // Wait for async task
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.genres.count, 1)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func test_loadNextPage_appendsMovies() async {
        // Given
        mockRepository.moviesResult = MoviesPageEntity(
            page: 1,
            movies: [MovieEntity.mock()],
            totalPages: 2,
            totalResults: 2
        )
        viewModel.onAppear()
        
        // Wait for initial load
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // When
        mockRepository.moviesResult = MoviesPageEntity(
            page: 2,
            movies: [MovieEntity(id: 2, title: "Movie 2", overview: "", posterPath: "", releaseYear: "2026", rating: 0.0, genreIds: [])],
            totalPages: 2,
            totalResults: 2
        )
        viewModel.loadNextPage()
        
        // Wait for async task
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[1].title, "Movie 2")
    }

    @MainActor
    func test_onSearch_filtersMovies() async {
        // Given
        let movie1 = MovieEntity(id: 1, title: "Batman", overview: "", posterPath: "", releaseYear: "2026", rating: 0.0, genreIds: [])
        let movie2 = MovieEntity(id: 2, title: "Superman", overview: "", posterPath: "", releaseYear: "2026", rating: 0.0, genreIds: [])
        mockRepository.moviesResult = MoviesPageEntity(
            page: 1,
            movies: [movie1, movie2],
            totalPages: 1,
            totalResults: 2
        )
        viewModel.onAppear()
        
        // Wait for initial load
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // When
        viewModel.onSearch(text: "bat")
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Batman")
    }

    @MainActor
    func test_toggleGenre_filtersMovies() async {
        // Given
        let genre1 = GenreEntity(id: 1, name: "Action")
        let genre2 = GenreEntity(id: 2, name: "Comedy")
        mockRepository.genresResult = [genre1, genre2]
        
        let movie1 = MovieEntity(id: 1, title: "Movie 1", overview: "", posterPath: "", releaseYear: "2026", rating: 0.0, genreIds: [1])
        let movie2 = MovieEntity(id: 2, title: "Movie 2", overview: "", posterPath: "", releaseYear: "2026", rating: 0.0, genreIds: [2])
        mockRepository.moviesResult = MoviesPageEntity(
            page: 1,
            movies: [movie1, movie2],
            totalPages: 1,
            totalResults: 2
        )
        
        viewModel.onAppear()
        
        // Wait for initial load
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // When
        viewModel.toggleGenre(genre1)
        
        // Wait for async task
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Movie 1")
    }
}

// MARK: - Mocks

final class MockMoviesRepository: MoviesRepository {
    var moviesResult: MoviesPageEntity?
    var genresResult: [GenreEntity] = []
    var movieDetailsResult: MovieDetailsEntity?
    
    func fetchGenres() async throws -> [GenreEntity] {
        return genresResult
    }
    
    func fetchMoviesList(page: Int) async throws -> MoviesPageEntity {
        guard let movies = moviesResult?.movies else {
            return MoviesPageEntity(page: 1, movies: [], totalPages: 1, totalResults: 0)
        }

        return MoviesPageEntity(
            page: moviesResult?.page ?? 1,
            movies: movies,
            totalPages: moviesResult?.totalPages ?? 1,
            totalResults: movies.count
        )
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetailsEntity {
        guard let details = movieDetailsResult else {
            throw NSError(domain: "MockError", code: 404, userInfo: nil)
        }
        return details
    }
}

// MARK: - Mock Models

extension MovieEntity {
    static func mock() -> MovieEntity {
        MovieEntity(id: 1, title: "Mock Movie", overview: "Mock overview", posterPath: "", releaseYear: "2026", rating: 7.5, genreIds: [1])
    }
}

extension GenreEntity {
    static func mock() -> GenreEntity {
        GenreEntity(id: 1, name: "Action")
    }
}
