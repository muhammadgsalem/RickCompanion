//
//  FetchCharactersUseCaseProtocol.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import DataRepository

public protocol FetchCharactersUseCaseProtocol {
    func execute(page: Int, status: String) async throws -> CharacterResponse
}

