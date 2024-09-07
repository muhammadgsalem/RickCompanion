//
//  APIGateDIContainer.swift
//  APIGate
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation

/// Dependency Injection Container for the APIGate module.
public final class APIGateDIContainer {
    public static let shared = APIGateDIContainer()
    
    private init() {}
    
    /// Creates and returns a new instance of NetworkProtocol.
    public func makeNetworking() -> NetworkProtocol {
        return URLSessionNetworking()
    }
    
    /// Creates and returns a new instance of Endpoint.
    ///
    /// - Parameters:
    ///   - path: The path component of the URL.
    ///   - method: The HTTP method for the request.
    ///   - parameters: The parameters to be included in the request.
    ///   - headers: The headers to be included in the request.
    /// - Returns: A new Endpoint instance.
    public func makeEndpoint(path: String, method: HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Endpoint {
        return ConcreteEndpoint(path: path, method: method, parameters: parameters, headers: headers)
    }
}

private struct ConcreteEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
}
