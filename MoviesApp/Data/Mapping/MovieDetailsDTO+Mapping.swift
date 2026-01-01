//
//  ds.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//


// MARK: - Mapper to Domain
extension MovieDetailsDTO {
    func toDomain() -> MovieDetailsEntity {
        
        var year: String {
            String(releaseDate?.split(separator: "-").first ?? "")
        }
        
        var posterUrl: String {
            "\(APIConstants.imagePathURL)\(posterPath)"
        }
        
        var backdropUrl: String {
            "\(APIConstants.imagePathURL)\(backdropPath)"
        }
        
        return MovieDetailsEntity(
            id: id,
            title: title,
            overview: overview,
            posterUrl: backdropUrl,
            backdropUrl: posterUrl,
            releaseYearMonth: year,
            genres: genres.map { $0.toDomain() },
            homepage: homepage,
            budget: budget,
            revenue: revenue,
            spokenLanguages: spokenLanguages.map { $0.englishName },
            status: status,
            runtime: runtime
        )
    }
}
