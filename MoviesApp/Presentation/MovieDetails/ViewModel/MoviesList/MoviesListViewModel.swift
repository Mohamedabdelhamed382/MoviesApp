//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Combine

final class MoviesListViewModel: MoviesListViewModelProtocols {
    
    // MARK: - Published Output
    @Published private(set) var movies: [MovieEntity] = []
    @Published private(set) var genres: [GenreEntity] = []
    @Published private(set) var selectedGenres: GenreEntity?
    @Published private(set) var isLoading = false

    // MARK: - Private
    private var allMovies: [MovieEntity] = []
    private var currentPage = 1
    private var searchText = ""

    private var moviesUseCase: FetchMoviesUseCase
    private var genresUseCase: FetchGenresUseCase

    // MARK: - Init
    init( moviesUseCase: FetchMoviesUseCase, genresUseCase: FetchGenresUseCase) {
        self.moviesUseCase = moviesUseCase
        self.genresUseCase = genresUseCase
    }
}

extension MoviesListViewModel {

    func onAppear() {
        loadMovies()
    }

    func loadNextPage() {
        guard !isLoading else { return }
        currentPage += 1
        loadMovies()
    }

    func search(text: String) {
       
    }

    func toggleGenre(_ genre: GenreEntity) {
        
    }
    
    func refreshData() {
        
    }
}

private extension MoviesListViewModel {
    func loadMovies() {
        
    }
}
