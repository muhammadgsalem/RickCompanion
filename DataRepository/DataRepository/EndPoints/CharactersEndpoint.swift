//
//  CharactersEndpoint.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//
import APIGate

struct CharactersEndpoint: Endpoint {
    let page: Int
    
    var path: String { "https://rickandmortyapi.com/api/character" }
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? { ["page": page] }
    var headers: [String: String]? { nil }

    init(page: Int) {
        self.page = page
    }
}
