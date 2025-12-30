//
//  APIClient.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 30/12/2025.
//

import Foundation
import Combine

@MainActor
protocol NetworkServiceProtocol {
    // Keep this nonisolated unless you specifically need main-actor access.
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws(APIError) -> T
}

@MainActor
final class NetworkService: NetworkServiceProtocol {

    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func request<T>(_ endpoint: Endpoint, type: T.Type) async throws(APIError) -> T where T : Decodable {
        guard let url = endpoint.url() else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        // 🖨 Print Request Info
        print("🚀 [REQUEST]")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "")")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }

        do {
            let (data, response) = try await urlSession.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("📩 [RESPONSE] Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }

            // 🖨 Pretty Print JSON Response
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("JSON Response:\n\(prettyString)")
            } else {
                print("Raw Response:\n\(String(data: data, encoding: .utf8) ?? "N/A")")
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("❌ Decoding Error: \(error)")
                throw APIError.decodingError(error)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            print("❌ Network Error: \(error)")
            throw APIError.networkError(error)
        }
    }
}
