//
//  MoviesListViewModel+Protocols.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import Combine

protocol MoviesListViewModelInput {
    func onAppear()
    func loadNextPage()
    func refreshData()
    func search(text: String)
    func toggleGenre(_ genre: GenreEntity)
}

protocol MoviesListViewModelOutput: ObservableObject {
    var movies: [MovieEntity] { get }
    var genres: [GenreEntity] { get }
    var selectedGenres: GenreEntity? { get }
    var isLoading: Bool { get }
}

typealias MoviesListViewModelProtocols = MoviesListViewModelInput & MoviesListViewModelOutput
