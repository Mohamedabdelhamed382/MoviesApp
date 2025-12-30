//
//  MovieDTO+Mapping.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

// MARK: - Movie Mapper
extension MovieDTO {
    func toDomain() -> MovieEntity {
        let year: String?
        if let releaseDate = releaseDate {
            year = String(releaseDate.split(separator: "-").first ?? "")
        } else {
            year = nil
        }
        
        return MovieEntity(
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
    func toDomain() -> MoviesPageEntity {
        MoviesPageEntity(
            page: page,
            movies: results.map { $0.toDomain() },
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
