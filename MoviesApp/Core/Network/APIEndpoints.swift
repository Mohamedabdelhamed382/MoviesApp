//
//  APIEndpoints.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//


import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOGYxNzAwYmM4ZWJkYTUzMDJlOTM4MDI4YTlkMDM4NyIsIm5iZiI6MTYzNzYxNDk2Ni43ODcwMDAyLCJzdWIiOiI2MTljMDU3NjQ5NzU2MDAwNjE1YjdjMzciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.U_maexpx43Ga1dvPnLnQlQJDAs0VP9yX_1sYlkjHRgk",
        "accept": "application/json"
    ]

    var body: Data? = nil

    func url() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3\(path)"
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url
    }
}

enum APIEndpoints {
    static func genres() -> Endpoint {
        Endpoint(
            path: "/genre/movie/list",
            method: .get,
            queryItems: [
                URLQueryItem(name: "language", value: "en")
            ]
        )
    }
}
