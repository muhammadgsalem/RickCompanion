//
//  CharacterRepositoryProtocol.swift
//  DataRepository
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGateProtocol
public protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
}

public enum CharacterRepositoryFactory {
    public static func defaultRepository(networking: NetworkProtocol = NetworkFactory.defaultNetworking()) -> CharacterRepositoryProtocol {
        return DefaultCharacterRepository(networking: networking)
    }
}
