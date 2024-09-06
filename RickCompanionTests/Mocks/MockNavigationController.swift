//
//  MockNavigationController.swift
//  RickCompanionTests
//
//  Created by Jimmy on 06/09/2024.
//

import XCTest
@testable import RickCompanion


class MockNavigationController: UINavigationController {
    @MainActor var pushedViewControllers: [UIViewController] = []

    @MainActor override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }
}
