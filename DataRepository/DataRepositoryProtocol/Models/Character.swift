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

    enum CodingKeys: String, CodingKey {
        case info, results
    }
    
    public struct PageInfo: Decodable {
        public let count: Int
        public let pages: Int
        public let next: URL?
        public let prev: URL?

        enum CodingKeys: String, CodingKey {
            case count, pages, next, prev
        }
    }
}



public struct Character: Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let gender: Gender
    public let location: Location
    public let image: URL

    enum CodingKeys: String, CodingKey {
        case id, name, status, species, gender, location, image
    }
    
    public init(
        id: Int,
        name: String,
        status: Status = .unknown,
        species: String,
        gender: Gender,
        location: Location,
        image: URL
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.location = location
        self.image = image
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(Status.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        gender = try container.decode(Gender.self, forKey: .gender)
        location = try container.decode(Location.self, forKey: .location)
        image = try container.decode(URL.self, forKey: .image)
    }
    
    public enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }

    public enum Gender: String, Decodable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown
    }

    public struct Location: Decodable {
        public let name: String

        enum CodingKeys: String, CodingKey {
            case name
        }
        
        public init(
            name: String
        ) {
            self.name = name
        }
    }
}



