//
//  NetworkError.swift
//  APIGate
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case unknownError(Error)
}
