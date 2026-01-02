//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import SwiftUI

struct MovieDetailsView<ViewModel: MovieDetailsViewModelProtocols>: View {
    
    @StateObject private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                backdropView
                detailsContent
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left").foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { openHomepage() } label: {
                    Image("share").foregroundColor(.white)
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .refreshable { viewModel.refreshData() }
        .onAppear { viewModel.onAppear() }
    }
    
    // MARK: - Backdrop / Header
    private var backdropView: some View {
        Group {
            if let urlString = viewModel.movie?.backdropUrl {
                CachedImageView(urlString: urlString) {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 320)
                .clipped()
            }
        }
    }
    
    // MARK: - Poster Image
    private var posterView: some View {
        Group {
            if let urlString = viewModel.movie?.posterUrl {
                CachedImageView(urlString: urlString) {
                    Color.gray.opacity(0.3)
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Details Content
    private var detailsContent: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity, minHeight: 300)
            } else if let movie = viewModel.movie {
                movieDetails(movie)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    private func movieDetails(_ movie: MovieDetailsEntity) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 16) {
                posterView
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(movie.title) (\(movie.releaseYearMonth))")
                        .font(.system(size: 14, weight: .semibold))
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(movie.genres.map(\.name).joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Text(movie.overview)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
            
            VStack(alignment: .leading) {
                infoRow("HomePage", movie.homepage)
                infoRow("Languages", movie.spokenLanguages.joined(separator: ","))
                HStack {
                    VStack(alignment: .leading) {
                        infoRow("Status", movie.status)
                        infoRow("Budget", movie.budget.map { "\($0.formatted()) $" })
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        infoRow("Runtime", "\(movie.runtime) minutes")
                        infoRow("Revenue", movie.revenue.map { "\($0.formatted()) $" })
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
    private func infoRow(_ title: String, _ value: String?) -> some View {
        HStack {
            Text("\(title):").foregroundColor(.white)
            if let value, let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
                Link(value, destination: url)
                    .underline(true, color: .blue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
            } else if let value {
                Text(value)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .font(.subheadline)
    }
    
    // MARK: - Actions
    private func openHomepage() {
        if let homepage = viewModel.movie?.homepage,
           let url = URL(string: homepage) {
            openURL(url)
        }
    }
}
