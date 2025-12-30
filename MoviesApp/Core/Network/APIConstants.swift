//
//  APIConstants.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

enum APIConstants {

    static var apiKey: String {
        Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""
    }

    static var authorization: String {
        Bundle.main.infoDictionary?["TMDB_AUTH_TOKEN"] as? String ?? ""
    }

    static let accept = "application/json"
}
