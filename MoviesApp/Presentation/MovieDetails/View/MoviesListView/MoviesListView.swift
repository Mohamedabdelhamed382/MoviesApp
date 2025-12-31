//
//  MoviesListView.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import SwiftUI

struct MoviesListView<ViewModel: MoviesListViewModelProtocols>: View {

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
          
        }
        .onAppear(perform: viewModel.onAppear)
    }
}
