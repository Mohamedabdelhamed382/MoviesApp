//
//  APIConstants.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

enum APIConstants {
    static var apiKey: String {
        let key = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""
        print("API Key loaded: \(key.isEmpty ? "EMPTY" : "LOADED")")
        return key
    }
    
    static var authorization: String {
        let token = Bundle.main.infoDictionary?["TMDB_AUTH_TOKEN"] as? String ?? ""
        print("Auth Token loaded: \(token.isEmpty ? "EMPTY" : "LOADED")")
        return token
    }
    
    static let accept = "application/json"
    
    static let imagePathURL = "https://image.tmdb.org/t/p/w500"

}
