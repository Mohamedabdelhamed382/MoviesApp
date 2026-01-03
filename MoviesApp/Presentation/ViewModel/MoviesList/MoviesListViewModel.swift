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
    @Published private(set) var isLoading = false
    @Published var selectedGenres: Set<GenreEntity?> = []
    @Published var searchText: String = ""
    
    // MARK: - Private
    private var allMovies: [MovieEntity] = [] // cache for local search
    private var currentPage = 1
    
    private let moviesUseCase: FetchMoviesUseCase
    private let genresUseCase: FetchGenresUseCase

    // MARK: - Init
    init(
        moviesUseCase: FetchMoviesUseCase,
        genresUseCase: FetchGenresUseCase
    ) {
        self.moviesUseCase = moviesUseCase
        self.genresUseCase = genresUseCase
    }
}

extension MoviesListViewModel {

    func onAppear() {
        Task {
            await loadMovies()
            await loadGenres()
        }
    }

    func loadNextPage() {
        guard !isLoading else { return }
        currentPage += 1
        Task {
            await loadMovies()
        }
    }

}

extension MoviesListViewModel {

    func onSearch(text: String) {
        searchText = text
        applyFilters()
    }

    func toggleGenre(_ genre: GenreEntity) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
        applyFilters()
    }

    func refreshData() {
        currentPage = 1
        movies = []
        allMovies = []
        Task { await loadMovies() }
    }
    
    private func applyFilters() {
        var filtered = allMovies
        
        // Apply genre filter
        let selectedGenreIds = Set(selectedGenres.compactMap { $0?.id })
        if !selectedGenreIds.isEmpty {
            filtered = filtered.filter { movie in
                !Set(movie.genreIds).isDisjoint(with: selectedGenreIds)
            }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        movies = filtered
    }
}

private extension MoviesListViewModel {
    
    func loadGenres() async {
        isLoading = true
        do {
            let result = try await genresUseCase.execute()
            genres = result
            
            isLoading = false
        } catch {
            isLoading = false
            print("Error loading movies: \(error)")
        }
    }
    
    func loadMovies() async {
            isLoading = true
            do {
                let result = try await moviesUseCase.execute(page: currentPage)
                
                allMovies.append(contentsOf: result.movies)
                applyFilters()
                isLoading = false
                
            } catch {
                isLoading = false
                print("Error loading movies: \(error)")
            }
        }
}
