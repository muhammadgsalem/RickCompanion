//
//  NetworkProtocol.swift
//  NetworkProtocol
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

/// Defines the contract for a networking layer in the application.
public protocol NetworkProtocol {
    /// Performs a network request and returns the decoded response.
    ///
    /// - Parameter endpoint: The `Endpoint` object containing all necessary information for the request.
    /// - Returns: The decoded response of type `T`.
    /// - Throws: A `NetworkError` if the request fails or the response cannot be decoded.
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

