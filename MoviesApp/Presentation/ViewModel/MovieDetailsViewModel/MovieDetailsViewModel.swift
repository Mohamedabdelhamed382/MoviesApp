//
//  MovieDetailsViewModel.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine
import Foundation

@MainActor
final class MovieDetailsViewModel: MovieDetailsViewModelProtocols {
    
    // Output
    @Published private(set) var movie: MovieDetailsEntity?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    // Dependencies
    private let movieId: Int
    private let useCase: FetchMovieDetailsUseCase
    
    init(movieId: Int, useCase: FetchMovieDetailsUseCase) {
        self.movieId = movieId
        self.useCase = useCase
    }
    
    // MARK: - Input
    func onAppear() {
        Task { await fetchMovieDetails() }
    }
    
    func refreshData() {
        Task { await fetchMovieDetails() }
    }
    
    // MARK: - Private
    private func fetchMovieDetails() async {
        isLoading = true
        errorMessage = nil
        do {
            let movieEntity = try await useCase.execute(movieId: movieId)
            self.movie = movieEntity
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
