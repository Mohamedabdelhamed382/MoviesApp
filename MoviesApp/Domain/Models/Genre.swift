//
//  Domain.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

struct GenresResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct Genre: Identifiable, Equatable {
    let id: Int
    let name: String
}
