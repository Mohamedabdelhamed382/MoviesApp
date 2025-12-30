//
//  MoviesApp.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import SwiftUI

@main
struct MoviesApp: App {
    
    init() {
            NetworkMonitor.shared.startMonitoring()
        }
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
