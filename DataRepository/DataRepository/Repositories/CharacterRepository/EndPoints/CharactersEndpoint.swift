//
//  CharactersEndpoint.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//
import APIGate

/// Defines the endpoint for fetching characters from the Rick and Morty API.
struct CharactersEndpoint: Endpoint {
    let page: Int
    let status: String
    
    var path: String { "https://rickandmortyapi.com/api/character" }
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? {
        var params: [String: Any] = ["page": page]
        if status != "all" {
            params["status"] = status
        }
        return params
    }
    var headers: [String: String]? { nil }

    /// Initializes a new instance of `CharactersEndpoint`.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - status: The status filter to apply.
    init(page: Int, status: String) {
        self.page = page
        self.status = status.lowercased()
    }
}
