//
//  Movie.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

// MARK: - Domain Models

struct Movie: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let imageUrl: String?      // Poster or backdrop URL
    let releaseYear: String?   // Extracted year from releaseDate
    let rating: Double
    let genreIds: [Int]
}

// MARK: - Mapper from DTO to Domain

extension Movie {
    init(dto: MovieDTO) {
        self.id = dto.id
        self.title = dto.title
        self.overview = dto.overview
        self.imageUrl = dto.posterPath ?? dto.backdropPath
        if let dateStr = dto.releaseDate, let year = dateStr.split(separator: "-").first {
            self.releaseYear = String(year)
        } else {
            self.releaseYear = nil
        }
        self.rating = dto.voteAverage
        self.genreIds = dto.genreIds
    }
}

struct MoviesPage {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
    let totalResults: Int
}

// MARK: - Mapper from DTO Response to Domain

extension MoviesPage {
    init(dto: MoviesResponseDTO) {
        self.page = dto.page
        self.movies = dto.results.map { Movie(dto: $0) }
        self.totalPages = dto.totalPages
        self.totalResults = dto.totalResults
    }
}
