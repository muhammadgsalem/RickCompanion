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

public struct Character: Identifiable, Decodable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let type: String?
    public let gender: Gender
    public let origin: Origin
    public let location: Location
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: Date

    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
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

public struct Origin: Decodable {
    public let name: String
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

public struct Location: Decodable {
    public let name: String
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

public extension Character {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(Status.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        gender = try container.decode(Gender.self, forKey: .gender)
        origin = try container.decode(Origin.self, forKey: .origin)
        location = try container.decode(Location.self, forKey: .location)
        image = try container.decode(String.self, forKey: .image)
        episode = try container.decode([String].self, forKey: .episode)
        url = try container.decode(String.self, forKey: .url)

        let createdString = try container.decode(String.self, forKey: .created)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        created = formatter.date(from: createdString) ?? Date()
    }
}
