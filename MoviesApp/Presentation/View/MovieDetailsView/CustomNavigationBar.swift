//
//  CustomNavigationBar.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 01/01/2026.
//


import SwiftUI

struct CustomNavigationBar: View {

    let title: String
    let leftButtonImage: String?
    let rightButtonImage: String?

    let onLeftButtonTap: (() -> Void)?
    let onRightButtonTap: (() -> Void)?

    var body: some View {
        HStack {
            // Left Button
            if let leftButtonImage {
                Button(action: {
                    onLeftButtonTap?()
                }) {
                    Image(systemName: leftButtonImage)
                        .font(.headline)
                }
            } else {
                Spacer().frame(width: 24)
            }

            Spacer()

            // Title
            Text(title)
                .font(.headline)
                .lineLimit(1)

            Spacer()

            // Right Button
            if let rightButtonImage {
                Button(action: {
                    onRightButtonTap?()
                }) {
                    Image(systemName: rightButtonImage)
                        .font(.headline)
                }
            } else {
                Spacer().frame(width: 24)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}
