//
//  Movie.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

struct MovieEntity: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let imageUrl: String?      // Poster or backdrop URL
    let releaseYear: String?   // Extracted year from releaseDate
    let rating: Double
    let genreIds: [Int]
}

struct MoviesPageEntity {
    let page: Int
    let movies: [MovieEntity]
    let totalPages: Int
    let totalResults: Int
}
