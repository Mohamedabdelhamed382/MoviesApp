//
//  SearchBar.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 31/12/2025.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var placeholder: String = "Search TMDB"
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .focused($isFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.clear)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.darkGray).opacity(0.6))
        )
        .padding(.horizontal)
    }
}
