//
//  MoviesListViewModel+Protocols.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import Combine

protocol MoviesListViewModelInput {
    
    var selectedGenres: Set<GenreEntity?> { get set}

    func onAppear()
    func loadNextPage()
    func refreshData()
    func toggleGenre(_ genre: GenreEntity)
    func onSearch(text: String)
}

protocol MoviesListViewModelOutput: ObservableObject {
    var movies: [MovieEntity] { get }
    var genres: [GenreEntity] { get }
    var isLoading: Bool { get }
    var searchText: String { get }
}

typealias MoviesListViewModelProtocols = MoviesListViewModelInput & MoviesListViewModelOutput
