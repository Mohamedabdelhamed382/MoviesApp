
import XCTest
import CoreData
@testable import MoviesApp

final class MoviesLocalDataSourceTests: XCTestCase {
    
    var sut: MoviesLocalDataSourceImpl!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
        sut = MoviesLocalDataSourceImpl(context: context)
        clearDatabase()
    }
    
    override func tearDown() {
        clearDatabase()
        sut = nil
        context = nil
        super.tearDown()
    }
    
    private func clearDatabase() {
        let entities = ["MovieCD", "GenreCD", "MovieDetailsCD"]
        for entityName in entities {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            if let objects = try? context.fetch(request) {
                for object in objects {
                    context.delete(object)
                }
            }
        }
        try? context.save()
    }
    
    func testSaveAndFetchMovies() {
        // Given
        let movie = MovieEntity(
            id: 1,
            title: "Test Movie",
            overview: "Overview",
            posterPath: "/path.jpg",
            releaseYear: "2024",
            rating: 8.5,
            genreIds: [1, 2]
        )
        let page = 1
        
        // When
        sut.saveMovies([movie], page: page)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for context perform")
        // Use perform because saveMovies uses context.perform (async)
        context.perform {
            let fetchedMovies = self.sut.fetchMovies(page: page, genres: nil)
            XCTAssertEqual(fetchedMovies.count, 1)
            XCTAssertEqual(fetchedMovies.first?.title, "Test Movie")
            XCTAssertEqual(fetchedMovies.first?.id, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSaveAndFetchGenres() {
        // Given
        let genres = [
            GenreEntity(id: 1, name: "Action"),
            GenreEntity(id: 2, name: "Comedy")
        ]
        
        // When
        sut.saveGenres(genres)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for context perform")
        context.perform {
            let fetchedGenres = self.sut.fetchGenres()
            XCTAssertEqual(fetchedGenres.count, 2)
            XCTAssertTrue(fetchedGenres.contains(where: { $0.name == "Action" }))
            XCTAssertTrue(fetchedGenres.contains(where: { $0.name == "Comedy" }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSaveAndFetchMovieDetails() {
        // Given
        let details = MovieDetailsEntity(
            id: 1,
            title: "Detailed Movie",
            overview: "Detailed Overview",
            posterUrl: "/poster.jpg",
            backdropUrl: "/backdrop.jpg",
            releaseYearMonth: "2024-01",
            genres: [GenreEntity(id: 1, name: "Action")],
            homepage: "https://example.com",
            budget: 1000000,
            revenue: 2000000,
            spokenLanguages: ["English"],
            status: "Released",
            runtime: 120
        )
        
        // When
        sut.saveMovieDetails(details)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for context perform")
        context.perform {
            let fetchedDetails = self.sut.fetchMovieDetails(id: 1)
            XCTAssertNotNil(fetchedDetails)
            XCTAssertEqual(fetchedDetails?.title, "Detailed Movie")
            XCTAssertEqual(fetchedDetails?.budget, 1000000)
            XCTAssertEqual(fetchedDetails?.runtime, 120)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchMoviesWithGenreFilter() {
        // Given
        let genre1 = GenreEntity(id: 10, name: "Sci-Fi")
        let genre2 = GenreEntity(id: 20, name: "Horror")
        sut.saveGenres([genre1, genre2])
        
        let movie1 = MovieEntity(id: 100, title: "Sci-Fi Movie", overview: "", posterPath: "", releaseYear: "", rating: 0, genreIds: [10])
        let movie2 = MovieEntity(id: 200, title: "Horror Movie", overview: "", posterPath: "", releaseYear: "", rating: 0, genreIds: [20])
        let movie3 = MovieEntity(id: 300, title: "Mixed Movie", overview: "", posterPath: "", releaseYear: "", rating: 0, genreIds: [10, 20])
        
        // When
        sut.saveMovies([movie1, movie2, movie3], page: 1)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for context perform")
        // Since both saveGenres and saveMovies use context.perform, the second one should happen after the first on the same context queue.
        context.perform {
            let filtered = self.sut.fetchMovies(page: 1, genres: [10])
            XCTAssertEqual(filtered.count, 2)
            XCTAssertTrue(filtered.contains(where: { $0.id == 100 }))
            XCTAssertTrue(filtered.contains(where: { $0.id == 300 }))
            XCTAssertFalse(filtered.contains(where: { $0.id == 200 }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
