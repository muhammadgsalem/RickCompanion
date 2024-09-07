//
//  Endpoint.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

/// Defines the structure of an API endpoint.
public protocol Endpoint {
    /// The path component of the URL.
    var path: String { get }
    
    /// The HTTP method for the request.
    var method: HTTPMethod { get }
    
    /// The parameters to be included in the request.
    var parameters: [String: Any]? { get }
    
    /// The headers to be included in the request.
    var headers: [String: String]? { get }
}

/// Represents HTTP methods for network requests.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
