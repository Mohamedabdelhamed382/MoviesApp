//
//  MoviesLocalDataSource.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import CoreData

protocol MoviesLocalDataSource {
    func saveMovies(_ movies: [MovieEntity], page: Int)
    func fetchMovies(page: Int, genres: [Int]?) -> [MovieEntity]
    
    func saveGenres(_ genres: [GenreEntity])
    func fetchGenres() -> [GenreEntity]
    
    func saveMovieDetails(_ details: MovieDetailsEntity)
    func fetchMovieDetails(id: Int) -> MovieDetailsEntity?
}

final class MoviesLocalDataSourceImpl: MoviesLocalDataSource {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    // MARK: - Movies
    
    func saveMovies(_ movies: [MovieEntity], page: Int) {
        Task {
            for movie in movies {
                if let url = URL(string: movie.posterPath) {
                    await ImageCacheService.shared.saveImage(from: url)
                }
            }
        }
        
        context.perform {
            for movie in movies {
                let request: NSFetchRequest<MovieCD> = MovieCD.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", movie.id)
                request.fetchLimit = 1
                
                do {
                    let existing = try self.context.fetch(request).first
                    let movieCD = existing ?? MovieCD(context: self.context)
                    
                    movieCD.id = Int64(movie.id)
                    movieCD.title = movie.title
                    movieCD.overview = movie.overview
                    movieCD.posterPath = movie.posterPath
                    movieCD.releaseDate = movie.releaseYear
                    movieCD.page = Int16(page)
                    
                    // Link with Genres
                    if !movie.genreIds.isEmpty {
                        let genreRequest: NSFetchRequest<GenreCD> = GenreCD.fetchRequest()
                        genreRequest.predicate = NSPredicate(format: "id IN %@", movie.genreIds)
                        if let genresCD = try? self.context.fetch(genreRequest) {
                            movieCD.setValue(NSSet(array: genresCD), forKey: "genres")
                        }
                    }
                    
                } catch {
                    print("Failed to fetch existing movie: \(error)")
                }
            }
            
            do {
                try self.context.save()
            } catch {
                print("Failed to save movies: \(error)")
            }
        }
    }
    
    func fetchMovies(page: Int, genres: [Int]?) -> [MovieEntity] {
        let request: NSFetchRequest<MovieCD> = MovieCD.fetchRequest()
        
        var predicates: [NSPredicate] = [
            NSPredicate(format: "page == %d", page)
        ]
        
        if let genres = genres, !genres.isEmpty {
            // Filter movies that have ANY of the selected genres relation
            // Core Data many-to-many filtering: SUBQUERY(genres, $g, $g.id IN %@).@count > 0
            let genrePredicate = NSPredicate(format: "SUBQUERY(genres, $g, $g.id IN %@).@count > 0", genres)
            predicates.append(genrePredicate)
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let result = try context.fetch(request)
            return result.map { mo in
                MovieEntity(
                    id: Int(mo.id),
                    title: mo.title ?? "",
                    overview: mo.overview ?? "",
                    posterPath: mo.posterPath ?? "",
                    releaseYear: mo.releaseDate ?? "",
                    rating: 0.0,
                    genreIds: []
                )
            }
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    // MARK: - Genres
    
    func saveGenres(_ genres: [GenreEntity]) {
        context.perform {
            for genre in genres {
                let request: NSFetchRequest<GenreCD> = GenreCD.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", genre.id)
                request.fetchLimit = 1
                
                do {
                    let existing = try self.context.fetch(request).first
                    let genreCD = existing ?? GenreCD(context: self.context)
                    
                    genreCD.id = Int16(genre.id)
                    genreCD.name = genre.name
                    
                } catch {
                    print("Failed to fetch existing genre: \(error)")
                }
            }
            
            do {
                try self.context.save()
            } catch {
                print("Failed to save genres: \(error)")
            }
        }
    }
    
    func fetchGenres() -> [GenreEntity] {
        let request: NSFetchRequest<GenreCD> = GenreCD.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.map { mo in
                GenreEntity(id: Int(mo.id), name: mo.name ?? "")
            }
        } catch {
            print("Failed to fetch genres: \(error)")
            return []
        }
    }
    
    // MARK: - Movie Details
    
    func saveMovieDetails(_ details: MovieDetailsEntity) {
        // Trigger background image caching
        Task {
            if let url = URL(string: details.posterUrl ?? "") {
                await ImageCacheService.shared.saveImage(from: url)
            }
            if let url = URL(string: details.backdropUrl ?? "") {
                await ImageCacheService.shared.saveImage(from: url)
            }
        }
        
        context.perform {
            let request: NSFetchRequest<MovieDetailsCD> = MovieDetailsCD.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", details.id)
            request.fetchLimit = 1
            
            do {
                let existing = try self.context.fetch(request).first
                let detailsCD = existing ?? MovieDetailsCD(context: self.context)
                
                detailsCD.id = Int64(details.id)
                detailsCD.budget = Int64(details.budget ?? 0)
                detailsCD.homepage = details.homepage
                detailsCD.revenue = Int64(details.revenue ?? 0)
                detailsCD.runtime = Int64(details.runtime)
                detailsCD.spokenLanguages = details.spokenLanguages.joined(separator: ",")
                detailsCD.status = details.status
                
                // Upsert MovieCD to ensure proper relationship and title/overview storage
                let movieRequest: NSFetchRequest<MovieCD> = MovieCD.fetchRequest()
                movieRequest.predicate = NSPredicate(format: "id == %d", details.id)
                let existingMovie = try self.context.fetch(movieRequest).first
                let movieCD = existingMovie ?? MovieCD(context: self.context)
                
                // Update basic movie info from details if available
                movieCD.id = Int64(details.id)
                movieCD.title = details.title
                movieCD.overview = details.overview
                movieCD.posterPath = details.posterUrl
                movieCD.releaseDate = details.releaseYearMonth
                
                // Link with Genres from Details
                let genreIds = details.genres.map { $0.id }
                if !genreIds.isEmpty {
                    let genreRequest: NSFetchRequest<GenreCD> = GenreCD.fetchRequest()
                    genreRequest.predicate = NSPredicate(format: "id IN %@", genreIds)
                    if let genresCD = try? self.context.fetch(genreRequest) {
                        movieCD.setValue(NSSet(array: genresCD), forKey: "genres")
                    }
                }
                
                // Link them
                detailsCD.movie = movieCD
                
                try self.context.save()
            } catch {
                print("Failed to save movie details: \(error)")
            }
        }
    }
    
    func fetchMovieDetails(id: Int) -> MovieDetailsEntity? {
        let request: NSFetchRequest<MovieDetailsCD> = MovieDetailsCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            if let mo = try context.fetch(request).first {
                return MovieDetailsEntity(
                    id: Int(mo.id),
                    title: mo.movie?.title ?? "",
                    overview: mo.movie?.overview ?? "",
                    posterUrl: mo.movie?.posterPath,
                    backdropUrl: nil,
                    releaseYearMonth: mo.movie?.releaseDate ?? "",
                    genres: [],
                    homepage: mo.homepage,
                    budget: Int(mo.budget),
                    revenue: Int(mo.revenue),
                    spokenLanguages: mo.spokenLanguages?.components(separatedBy: ",") ?? [],
                    status: mo.status,
                    runtime: Int(mo.runtime)
                )
            }
            return nil
        } catch {
            print("Failed to fetch movie details: \(error)")
            return nil
        }
    }
}
