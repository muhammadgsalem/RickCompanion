//
//  RepositoryError.swift
//  DataRepository
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import APIGate

public enum RepositoryError: Error {
    case invalidRequest
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case unknown(Error)
    
}
