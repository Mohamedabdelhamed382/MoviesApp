//
//  APIEndpoints.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

struct Endpoint: Sendable {
    let path: String
    let method: HTTPMethod
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "language", value: "en")
    ]
    var headers: [String: String] = [
        "Authorization": APIConstants.authorization,
        "accept": APIConstants.accept
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
            method: .get
        )
    }
    
    static func moviesList(page: Int) -> Endpoint {
        return Endpoint(
            path: "/discover/movie",
            method: .get,
            queryItems: [
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }
    
    static func movieDetails(id: Int) -> Endpoint {
        return Endpoint(
            path: "/movie/\(id)",
            method: .get,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US")
            ]
        )
    }
}
