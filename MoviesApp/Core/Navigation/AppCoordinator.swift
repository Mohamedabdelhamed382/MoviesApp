//
//  AppCoordinator.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    // MARK: - Start View
    @ViewBuilder
    func start() -> some View {
        build(route: .moviesList)
    }

    // MARK: - Navigation Builder
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .moviesList:
            MoviesListBuilder.build()
        }
    }
}
