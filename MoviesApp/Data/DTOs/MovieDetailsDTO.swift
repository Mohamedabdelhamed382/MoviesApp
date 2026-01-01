//
//  MovieDetailsDTO.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import Foundation

struct MovieDetailsDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let backdropPath: String
    let releaseDate: String?
    let runtime: Int
    let voteAverage: Double
    let genres: [GenreDTO]
    let homepage: String?
    let budget: Int?
    let revenue: Int?
    let spokenLanguages: [SpokenLanguageDTO]
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, homepage, budget, revenue, status
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case spokenLanguages = "spoken_languages"
    }
}

struct SpokenLanguageDTO: Decodable {
    let iso639_1: String
    let englishName: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case englishName = "english_name"
        case name
    }
}
