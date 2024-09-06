//
//  BusinessLayerTests.swift
//  BusinessLayerTests
//
//  Created by Jimmy on 03/09/2024.
//

@testable import BusinessLayer
@testable import DataRepository
import XCTest

class FetchCharactersUseCaseTests: XCTestCase {
    var sut: FetchCharactersUseCase!
    var mockRepository: MockCharacterRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        sut = FetchCharactersUseCase(characterRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    /*
     testExecuteSuccess:

     This test verifies that when the repository returns a successful response, the use case correctly processes and returns the character data.
     We set up a mock successful response and check if the returned data matches our expectations.
     */
    func testExecuteSuccess() async throws {
        // Given
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/rick.jpg")!),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/morty.jpg")!)
        ]
        let expectedResponse = CharacterResponse(info: PageInfo(count: 2, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        mockRepository.fetchCharactersResult = .success(expectedResponse)

        // When
        let result = try await sut.execute(page: 1, status: "alive")

        // Then
        XCTAssertEqual(result.results.count, 2)
        XCTAssertEqual(result.results[0].name, "Rick")
        XCTAssertEqual(result.results[1].name, "Morty")
    }

    /*
     testExecuteRepositoryError:

     This test checks how the use case handles a repository error.
     We expect the use case to wrap the RepositoryError in a BusinessError.repositoryError.
     */

    func testExecuteRepositoryError() async {
        // Given
        mockRepository.fetchCharactersResult = .failure(RepositoryError.serverError(statusCode: 500))

        // When/Then
        do {
            _ = try await sut.execute(page: 1, status: "alive")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is BusinessError)
            if case let BusinessError.repositoryError(repositoryError) = error {
                XCTAssertEqual(repositoryError, RepositoryError.serverError(statusCode: 500))
            } else {
                XCTFail("Unexpected error type")
            }
        }
    }

    /*
     testExecuteInvalidDataError:

     This test verifies how the use case handles a scenario where the repository returns valid but empty data.
     In this case, we expect the use case to return the empty result without throwing an error.
     */
    func testExecuteInvalidDataError() async {
        // Given
        mockRepository.fetchCharactersResult = .success(CharacterResponse(info: PageInfo(count: 0, pages: 0, next: nil, prev: nil), results: []))

        // When/Then
        do {
            let result = try await sut.execute(page: 1, status: "alive")
            XCTAssertTrue(result.results.isEmpty, "Expected empty result for invalid data")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    /*
     testExecuteUnknownError:

     This test checks how the use case handles an unknown error type from the repository.
     We expect the use case to wrap the unknown error in a BusinessError.unknown.
     */

    func testExecuteUnknownError() async {
        // Given
        struct UnknownError: Error {}
        mockRepository.fetchCharactersResult = .failure(UnknownError())

        // When/Then
        do {
            _ = try await sut.execute(page: 1, status: "alive")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is BusinessError)
            if case BusinessError.unknown = error {
                // Expected error
            } else {
                XCTFail("Unexpected error type")
            }
        }
    }
}
