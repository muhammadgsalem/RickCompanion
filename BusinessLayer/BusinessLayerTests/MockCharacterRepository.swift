//
//  MockCharacterRepository.swift
//  BusinessLayerTests
//
//  Created by Jimmy on 06/09/2024.
//

import Foundation
@testable import BusinessLayer
@testable import DataRepository

class MockCharacterRepository: CharacterRepositoryProtocol {
    var fetchCharactersResult: Result<CharacterResponse, Error> = .success(CharacterResponse(info: PageInfo(count: 0, pages: 0, next: nil, prev: nil), results: []))

    func fetchCharacters(page: Int, status: String) async throws -> CharacterResponse {
        switch fetchCharactersResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
