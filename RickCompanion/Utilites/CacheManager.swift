//
//  CacheManager.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import UIKit

actor CacheManager {
    static let shared = CacheManager()

    private var cache = NSCache<NSString, AnyObject>()
    private var runningTasks = [String: Task<AnyObject, Error>]()

    private init() {}

    func value<T>(forKey key: String) -> T? {
        cache.object(forKey: key as NSString) as? T
    }

    func setValue<T>(_ value: T, forKey key: String) {
        cache.setObject(value as AnyObject, forKey: key as NSString)
    }

    func loadResource<T: AnyObject>(
        withKey key: String,
        generator: @escaping () async throws -> T
    ) async throws -> T {
        if let cachedValue: T = value(forKey: key) {
            return cachedValue
        }

        if let existingTask = runningTasks[key] {
            return try await existingTask.value as! T
        }

        let task = Task {
            let result = try await generator()
            setValue(result, forKey: key)
            runningTasks[key] = nil
            return result as AnyObject
        }

        runningTasks[key] = task
        return try await task.value as! T
    }
}

extension URL {
    func loadImage() async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: self)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}
