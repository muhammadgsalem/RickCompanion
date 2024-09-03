//
//  CharactersEndpoint.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//

public struct CharactersEndpoint: Endpoint {
    public var path: String {
        return "https://rickandmortyapi.com/api/character"
    }

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: [String: Any]? {
        return ["page": page]
    }

    public var headers: [String: String]? {
        return nil
    }

    private let page: Int

    public init(page: Int) {
        self.page = page
    }
}
