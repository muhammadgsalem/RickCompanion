//
//  MockFetchCharactersUseCase.swift
//  RickCompanionTests
//
//  Created by Jimmy on 06/09/2024.
//

import XCTest
@testable import RickCompanion
@testable import BusinessLayer
@testable import DataRepository

class MockFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    var executeResult: Result<CharacterResponse, Error> = .success(CharacterResponse(info: PageInfo(count: 0, pages: 0, next: nil, prev: nil), results: []))

    func execute(page: Int, status: String) async throws -> CharacterResponse {
        switch executeResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
