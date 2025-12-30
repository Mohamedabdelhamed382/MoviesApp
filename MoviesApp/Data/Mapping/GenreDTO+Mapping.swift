//
//  Mapping.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

extension GenreDTO {
    func toDomain() -> GenreEntity {
        GenreEntity(id: id, name: name)
    }
}
