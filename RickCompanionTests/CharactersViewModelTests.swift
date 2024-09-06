//
//  RickCompanionTests.swift
//  RickCompanionTests
//
//  Created by Jimmy on 02/09/2024.
//

@testable import BusinessLayer
@testable import DataRepository
@testable import RickCompanion
import XCTest

class CharactersViewModelTests: XCTestCase {
    var sut: CharactersViewModel!
    var mockUseCase: MockFetchCharactersUseCase!
    var mockDelegate: MockCharactersViewModelDelegate!

    @MainActor override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCharactersUseCase()
        sut = CharactersViewModel(fetchCharactersUseCase: mockUseCase)
        mockDelegate = MockCharactersViewModelDelegate()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockDelegate = nil
        super.tearDown()
    }

    /*
     testLoadCharactersSuccess: Verifies that the view model correctly processes successful character fetching.
     */
    func testLoadCharactersSuccess() async throws {
        // Given
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/rick.jpg")!),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/morty.jpg")!)
        ]
        let expectedResponse = CharacterResponse(info: PageInfo(count: 2, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        mockUseCase.executeResult = .success(expectedResponse)

        // When
        await sut.loadCharacters()

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.characters.count, 2)
            XCTAssertEqual(sut.characters[0].name, "Rick")
            XCTAssertEqual(sut.characters[1].name, "Morty")
            XCTAssertEqual(mockDelegate.lastState, .loaded(expectedCharacters))
        }
    }

    /*
     testLoadCharactersError: Checks how the view model handles errors from the use case.
     */
    func testLoadCharactersError() async throws {
        // Given
        let expectedError = BusinessError.repositoryError(.serverError(statusCode: 500))
        mockUseCase.executeResult = .failure(expectedError)

        // When
        await sut.loadCharacters()

        // Then
        await MainActor.run {
            XCTAssertTrue(sut.characters.isEmpty)
            XCTAssertEqual(mockDelegate.lastState, .error(expectedError))
        }
    }

    /*
     testApplyFilter: Tests the filter application functionality.
     */
    func testApplyFilter() async throws {
        // Given
        let filter = CharacterStatus.alive
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, location: Character.Location(name: "Earth"), image: URL(string: "https://example.com/rick.jpg")!)
        ]
        let expectedResponse = CharacterResponse(info: PageInfo(count: 1, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        mockUseCase.executeResult = .success(expectedResponse)

        // When
        await MainActor.run {
            sut.applyFilter(filter)
        }
        await sut.loadCharacters()

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.currentFilter, filter)
            XCTAssertEqual(sut.characters.count, 1)
            XCTAssertEqual(sut.characters[0].name, "Rick")
            XCTAssertEqual(mockDelegate.lastState, .loaded(expectedCharacters))
        }
    }
}
