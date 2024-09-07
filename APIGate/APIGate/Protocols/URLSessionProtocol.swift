//
//  URLSessionProtocol.swift
//  APIGate
//
//  Created by Jimmy on 06/09/2024.
//

import Foundation
/// A protocol that defines the interface for URL session data tasks.
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
