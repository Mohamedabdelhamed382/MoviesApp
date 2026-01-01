//
//  MovieDetailsViewModel+Protocols.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 01/01/2026.
//

import Combine

// MARK: - Input
protocol MovieDetailsViewModelInput {
    func onAppear()
    func refreshData()
}

// MARK: - Output
protocol MovieDetailsViewModelOutput: ObservableObject {
    var movie: MovieDetailsEntity? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

// MARK: - Typealias for convenience
typealias MovieDetailsViewModelProtocols = MovieDetailsViewModelInput & MovieDetailsViewModelOutput
