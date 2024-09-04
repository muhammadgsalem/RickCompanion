//
//  NetworkProtocol.swift
//  NetworkProtocol
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

public protocol NetworkProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

public enum NetworkFactory {
    public static func defaultNetworking() -> NetworkProtocol {
        return URLSessionNetworking()
    }
}
