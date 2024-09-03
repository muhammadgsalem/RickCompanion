//
//  CharacterRepository.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation
import APIGate

public class CharacterRepository: CharacterRepositoryProtocol {
    private let networking: Networking

    public init(networking: Networking = URLSessionNetworking()) {
        self.networking = networking
    }

    public func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        let endpoint = CharactersEndpoint(page: page)
        networking.request(endpoint, completion: completion)
    }
}
