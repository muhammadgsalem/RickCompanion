//
//  AppCoordinatorTests.swift
//  RickCompanionTests
//
//  Created by Jimmy on 06/09/2024.
//
import XCTest
@testable import RickCompanion

class AppCoordinatorTests: XCTestCase {
    var sut: AppCoordinator!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        sut = AppCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        sut = nil
        mockNavigationController = nil
        super.tearDown()
    }
/*
 testStart: Ensures that the coordinator starts by pushing a CharactersViewController onto the navigation stack.
 */
    func testStart() async throws {
        // When
        await MainActor.run {
            sut.start()
        }

        // Then
        await MainActor.run {
            XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1)
            XCTAssertTrue(mockNavigationController.pushedViewControllers[0] is CharactersViewController)
        }
    }
}
