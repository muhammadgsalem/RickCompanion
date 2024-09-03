//
//  Networking.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

public protocol Networking {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}
