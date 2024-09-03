//
//  MainCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencyContainer: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        let charactersViewController = dependencyContainer.makeCharactersViewController()
        charactersViewController.coordinator = self
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }

    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }

    func dismissViewController() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
