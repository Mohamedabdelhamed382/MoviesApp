//
//  MovieDTO.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

struct MoviesResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
}

// MARK: - Movie Mapper
extension MovieDTO {
    func toDomain() -> Movie {
        let year: String?
        if let releaseDate = releaseDate {
            year = String(releaseDate.split(separator: "-").first ?? "")
        } else {
            year = nil
        }
        
        return Movie(
            id: id,
            title: title,
            overview: overview,
            imageUrl: posterPath ?? backdropPath,
            releaseYear: year,
            rating: voteAverage,
            genreIds: genreIds
        )
    }
}

// MARK: - Movies Page Mapper
extension MoviesResponseDTO {
    func toDomain() -> MoviesPage {
        MoviesPage(
            page: page,
            movies: results.map { $0.toDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
