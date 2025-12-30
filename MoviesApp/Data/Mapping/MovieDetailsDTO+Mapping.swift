//
//  ds.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//


// MARK: - Mapper to Domain
extension MovieDetailsDTO {
    func toDomain() -> MovieDetailsEntity {
        return MovieDetailsEntity(
            id: id,
            title: title,
            overview: overview,
            posterUrl: posterPath,
            backdropUrl: backdropPath,
            releaseYearMonth: releaseDate.flatMap {
                let components = $0.split(separator: "-")
                return components.count >= 2 ? "\(components[0])-\(components[1])" : String(components.first ?? "")
            },
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