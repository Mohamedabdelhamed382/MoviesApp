//
//  MovieDTO+Mapping.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

// MARK: - Movie Mapper
extension MovieDTO {
    func toDomain() -> MovieEntity {
        var year: String {
            String(releaseDate.split(separator: "-").first ?? "")
        }
        
        var imageUrl: String {
           "\(APIConstants.imagePathURL)\(posterPath)"
        }
        
        return MovieEntity(
            id: id,
            title: title,
            overview: overview,
            posterPath: imageUrl,
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
