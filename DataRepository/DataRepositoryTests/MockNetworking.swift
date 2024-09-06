//
//  MockNetworking.swift
//  DataRepositoryTests
//
//  Created by Jimmy on 06/09/2024.
//

import Foundation
@testable import DataRepository
@testable import APIGate
class MockNetworking: NetworkProtocol {
    var mockResult: Result<Decodable, Error> = .success(CharacterResponse(info: PageInfo(count: 0, pages: 0, next: nil, prev: nil), results: []))

    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        switch mockResult {
        case .success(let response):
            guard let response = response as? T else {
                throw NetworkError.decodingError
            }
            return response
        case .failure(let error):
            throw error
        }
    }
}
