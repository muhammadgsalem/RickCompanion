//
//  APIGateTests.swift
//  APIGateTests
//
//  Created by Jimmy on 03/09/2024.
//

@testable import APIGate
import XCTest

class URLSessionNetworkingTests: XCTestCase {
    var sut: URLSessionNetworking!
    var mockURLSessionProtocol: MockURLSessionProtocol!

    override func setUp() {
        super.setUp()
        mockURLSessionProtocol = MockURLSessionProtocol()
        sut = URLSessionNetworking(session: mockURLSessionProtocol)
    }

    override func tearDown() {
        sut = nil
        mockURLSessionProtocol = nil
        super.tearDown()
    }

    /*
     testSuccessfulRequest:

     This test simulates a successful API call.
     We set up the mock session to return valid JSON data and a 200 status code.
     We then make a request and verify that the data is correctly decoded.
     */
    func testSuccessfulRequest() async throws {
        // Given
        let expectedData = """
        {
            "id": 1,
            "name": "Rick Sanchez"
        }
        """.data(using: .utf8)!

        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockURLSessionProtocol.mockDataTask = (expectedData, response)

        let endpoint = MockEndpoint(path: "https://example.com/api", method: .get)

        // When
        let result: MockDecodable = try await sut.request(endpoint)

        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Rick Sanchez")
    }

    /*
     testFailedRequestInvalidURL:

     This test checks the behavior when an invalid URL is provided.
     We expect the request method to throw a NetworkError.invalidURL error.
     */

    func testFailedRequestInvalidURL() async {
        // Given
        let endpoint = MockEndpoint(path: "", method: .get)

        // When/Then
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            XCTFail("Expected to throw an error, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }

    /*
     testFailedRequestServerError:

     This test simulates a server error (status code 500).
     We expect the request method to throw a NetworkError.serverError with the correct status code.
     */

    func testFailedRequestServerError() async {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        mockURLSessionProtocol.mockDataTask = (Data(), response)

        let endpoint = MockEndpoint(path: "https://example.com/api", method: .get)

        // When/Then
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            XCTFail("Expected to throw an error, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, .serverError(statusCode: 500))
        }
    }

    /*
     testFailedRequestDecodingError:

     This test checks what happens when the server returns invalid JSON that can't be decoded.
     We expect the request method to throw a NetworkError.decodingError.
     */

    func testFailedRequestDecodingError() async {
        // Given
        let invalidData = "Invalid JSON".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockURLSessionProtocol.mockDataTask = (invalidData, response)

        let endpoint = MockEndpoint(path: "https://example.com/api", method: .get)

        // When/Then
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            XCTFail("Expected to throw an error, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, .decodingError)
        }
    }
}
