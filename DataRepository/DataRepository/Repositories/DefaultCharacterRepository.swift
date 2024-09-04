//
//  DefaultCharacterRepository.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGateProtocol
// Default implementation
public class DefaultCharacterRepository: CharacterRepositoryProtocol {
    private let networking: NetworkProtocol

    public init(networking: NetworkProtocol) {
        self.networking = networking
    }

    public func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        let endpoint = CharactersEndpoint(page: page)
        networking.request(endpoint, completion: completion)
    }
}
