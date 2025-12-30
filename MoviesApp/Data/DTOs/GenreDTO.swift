//
//  GenreDTO.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

extension GenreDTO {
    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}
