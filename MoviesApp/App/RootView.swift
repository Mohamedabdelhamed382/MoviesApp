//
//  RootView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            Text("Welcome to MoviesApp")
                .font(.title)
                .padding()
                .navigationTitle("Movies")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
