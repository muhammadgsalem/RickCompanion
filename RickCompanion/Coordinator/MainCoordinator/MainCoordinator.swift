//
//  MainCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let dependencyContainer: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        let charactersCoordinator = CharactersCoordinator(navigationController: navigationController, dependencyContainer: dependencyContainer)
        coordinate(to: charactersCoordinator)
    }
}
