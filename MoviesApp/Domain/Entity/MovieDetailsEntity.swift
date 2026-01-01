//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//


struct MovieDetailsEntity {
    let id: Int
    let title: String
    let overview: String
    let posterUrl: String?
    let backdropUrl: String?
    let releaseYearMonth: String   // YYYY-MM
    let genres: [GenreEntity]
    let homepage: String?
    let budget: Int?
    let revenue: Int?
    let spokenLanguages: [String]
    let status: String?
    let runtime: Int
}
