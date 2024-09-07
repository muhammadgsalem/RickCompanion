//
//  URLExtension.swift
//  APIGate
//
//  Created by Jimmy on 03/09/2024.
//

import Foundation


extension URL {
    /// Appends query parameters to the URL.
    ///
    /// - Parameter parameters: A dictionary of query parameters to append.
    /// - Returns: A new URL with the appended query parameters, or nil if the URL couldn't be created.
    func appendingQueryParameters(_ parameters: [String: Any]) -> URL? {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let existingQueryItems = urlComponents?.queryItems ?? []
        let queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: "\(value)")
        }
        urlComponents?.queryItems = existingQueryItems + queryItems
        return urlComponents?.url
    }
}
