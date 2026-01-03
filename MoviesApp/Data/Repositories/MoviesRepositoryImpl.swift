//
//  MoviesRepositoryImpl.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

final class MoviesRepositoryImpl: MoviesRepository {
    
    // MARK: - Dependencies
    private let remoteDataSource: MoviesRemoteDataSource
    private let localDataSource: MoviesLocalDataSource

    // MARK: - Init
    init(
        remoteDataSource: MoviesRemoteDataSource,
        localDataSource: MoviesLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    // MARK: - Genres
    func fetchGenres() async throws -> [GenreEntity] {
        // 1. Try Local first
        let localGenres = localDataSource.fetchGenres()
        if !localGenres.isEmpty {
            return localGenres
        }
        
        // 2. Fetch Remote
        let dtos = try await remoteDataSource.fetchGenres()
        let genres = dtos.map { $0.toDomain() }
        
        // 3. Save Local
        localDataSource.saveGenres(genres)
        
        return genres
    }
    
    // MARK: - Movies
    func fetchMoviesList(page: Int) async throws -> MoviesPageEntity {
        do {
            // 1. Fetch Remote
            let responseDTO = try await remoteDataSource.fetchMoviesList(page: page)
            let domain = responseDTO.toDomain()
            
            // 2. Save Local
            localDataSource.saveMovies(domain.movies, page: page)
            
            return domain
        } catch {
            // 3. Fallback to Local if remote fails
            let localMovies = localDataSource.fetchMovies(page: page)
            if !localMovies.isEmpty {
                // For local, we might not have totalPages/totalResults; provide reasonable fallbacks.
                return MoviesPageEntity(
                    page: page,
                    movies: localMovies,
                    totalPages: 1000,          // Arbitrary high number for offline scrolling
                    totalResults: localMovies.count
                )
            }
            throw error
        }
    }

    // MARK: - Movie Details
    func fetchMovieDetails(id: Int) async throws -> MovieDetailsEntity {
        do {
            // 1. Fetch Remote
            let dto = try await remoteDataSource.fetchMovieDetails(id: id)
            let domain = dto.toDomain()
            
            // 2. Save Local
            localDataSource.saveMovieDetails(domain)
            
            return domain
        } catch {
            // 3. Fallback Local
            if let localDetails = localDataSource.fetchMovieDetails(id: id) {
                return localDetails
            }
            throw error
        }
    }
}
