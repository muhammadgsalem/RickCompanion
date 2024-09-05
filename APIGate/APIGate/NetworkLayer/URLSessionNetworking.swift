//
//  URLSessionNetworking.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation

final class URLSessionNetworking: NetworkProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        configureRequest(&request, with: endpoint)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func configureRequest(_ request: inout URLRequest, with endpoint: Endpoint) {
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = endpoint.parameters {
            request.url = request.url?.appendingQueryParameters(parameters)
        }
    }
}
