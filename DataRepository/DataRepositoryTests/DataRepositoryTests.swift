//
//  DataRepositoryTests.swift
//  DataRepositoryTests
//
//  Created by Jimmy on 03/09/2024.
//

@testable import APIGate
@testable import DataRepository
import XCTest

class CharacterRepositoryTests: XCTestCase {
    var sut: CharacterRepository!
    var mockNetworking: MockNetworking!

    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworking()
        sut = CharacterRepository(networking: mockNetworking)
    }

    override func tearDown() {
        sut = nil
        mockNetworking = nil
        super.tearDown()
    }

    /*
     testFetchCharactersSuccess:

     This test verifies that when the networking layer returns a successful response, the repository correctly parses and returns the character data.
     We set up a mock successful response and check if the returned data matches our expectations.
     */
    func testFetchCharactersSuccess() async throws {
        // Given
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/rick.jpg")!),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/morty.jpg")!)
        ]
        let expectedResponse = CharacterResponse(info: PageInfo(count: 2, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        mockNetworking.mockResult = .success(expectedResponse)

        // When
        let result = try await sut.fetchCharacters(page: 1, status: "alive")

        // Then
        XCTAssertEqual(result.results.count, 2)
        XCTAssertEqual(result.results[0].name, "Rick")
        XCTAssertEqual(result.results[1].name, "Morty")
    }

    /*
     testFetchCharactersInvalidURLError:

     This test checks how the repository handles an invalid URL error from the networking layer.
     We expect the repository to convert the NetworkError.invalidURL to a RepositoryError.invalidRequest.
     */
    func testFetchCharactersInvalidURLError() async {
        // Given
        mockNetworking.mockResult = .failure(NetworkError.invalidURL)

        // When/Then
        do {
            _ = try await sut.fetchCharacters(page: 1, status: "alive")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is RepositoryError)
            XCTAssertEqual(error as? RepositoryError, .invalidRequest)
        }
    }

    /*
     testFetchCharactersServerError:

     This test verifies the handling of a server error (e.g., 500 status code).
     We expect the repository to pass through the server error with the same status code.
         */
    func testFetchCharactersServerError() async {
        // Given
        mockNetworking.mockResult = .failure(NetworkError.serverError(statusCode: 500))

        // When/Then
        do {
            _ = try await sut.fetchCharacters(page: 1, status: "alive")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is RepositoryError)
            XCTAssertEqual(error as? RepositoryError, .serverError(statusCode: 500))
        }
    }
    /*
     testFetchCharactersDecodingError:

     This test checks how the repository handles a decoding error from the networking layer.
     We expect the repository to convert the NetworkError.decodingError to a RepositoryError.invalidResponse.
         */
    func testFetchCharactersDecodingError() async {
        // Given
        mockNetworking.mockResult = .failure(NetworkError.decodingError)

        // When/Then
        do {
            _ = try await sut.fetchCharacters(page: 1, status: "alive")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is RepositoryError)
            XCTAssertEqual(error as? RepositoryError, .invalidResponse)
        }
    }
}
