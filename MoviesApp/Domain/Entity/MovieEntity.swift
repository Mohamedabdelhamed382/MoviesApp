//
//  Movie.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

struct MoviesPageEntity {
    let page: Int
    let movies: [MovieEntity]
    let totalPages: Int
    let totalResults: Int
}

struct MovieEntity: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseYear: String
    let rating: Double
    let genreIds: [Int]
}
