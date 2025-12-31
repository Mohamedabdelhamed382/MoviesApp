//
//  NetworkServiceTests.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 01/01/2026.
//


import XCTest
@testable import MoviesApp

@MainActor
final class NetworkServiceTests: XCTestCase {

    struct MockResponse: Codable {
        let name: String
    }

    var networkService: NetworkService!
    var mockSession: URLSession!

    override func setUp() {
        super.setUp()

        // 1️⃣ Create a custom URLProtocol to intercept requests
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)

        networkService = NetworkService(urlSession: mockSession)
    }

    override func tearDown() {
        networkService = nil
        mockSession = nil
        super.tearDown()
    }

    func testRequestReturnsMockData() async throws {
        // 2️⃣ Prepare mock data
        let mockData = try JSONEncoder().encode(MockResponse(name: "Action"))
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }

        // 3️⃣ Create dummy endpoint
        let endpoint = Endpoint(path: "genres", method: .get)

        // 4️⃣ Call request
        let response: MockResponse = try await networkService.request(endpoint, type: MockResponse.self)

        XCTAssertEqual(response.name, "Action")
    }
}

// ✅ MockURLProtocol to intercept requests
final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
