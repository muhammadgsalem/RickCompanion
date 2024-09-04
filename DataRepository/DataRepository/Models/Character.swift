//
//  Character.swift
//  BusinessLayer
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

public struct CharacterResponse: Decodable {
    public let info: PageInfo
    public let results: [Character]
}

public struct PageInfo: Decodable {
    public let count: Int
    public let pages: Int
    public let next: URL?
    public let prev: URL?
}

public struct Character: Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let gender: Gender
    public let location: Location
    public let image: URL
    
    public init(id: Int, name: String, status: Status, species: String, gender: Gender, location: Location, image: URL) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.location = location
        self.image = image
    }
}

public extension Character {
    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }

    enum Gender: String, Decodable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown
    }

    struct Location: Decodable {
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
}
