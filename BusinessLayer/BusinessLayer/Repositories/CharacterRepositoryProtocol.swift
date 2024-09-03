//
//  CharacterRepository.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

public protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void)
}
