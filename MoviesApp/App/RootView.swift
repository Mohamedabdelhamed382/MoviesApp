//
//  RootView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import SwiftUI

struct RootView: View {

    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.start()
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route: route)
                }
        }
    }
}
