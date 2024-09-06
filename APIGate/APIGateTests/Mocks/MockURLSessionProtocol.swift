//
//  MockURLSessionProtocol.swift
//  APIGateTests
//
//  Created by Jimmy on 06/09/2024.
//

import XCTest
@testable import APIGate

// MARK: - Helper Classes

class MockURLSessionProtocol: URLSessionProtocol {
    var mockDataTask: (Data, URLResponse)!

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return mockDataTask
    }
}

struct MockEndpoint: Endpoint {
    var path: String
    var method: HTTPMethod
    var parameters: [String : Any]?
    var headers: [String : String]?
}

struct MockDecodable: Decodable {
    let id: Int
    let name: String
}
