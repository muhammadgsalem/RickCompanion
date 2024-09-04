//
//  CharactersCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import UIKit
import DataRepositoryProtocol

final class CharactersCoordinator: ViewCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    weak var viewController: CharactersViewController?
    
    private let dependencyContainer: DependencyContainerProtocol

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        let charactersViewController = dependencyContainer.makeCharactersViewController()
        charactersViewController.coordinator = self
        viewController = charactersViewController
        navigationController.pushViewController(charactersViewController, animated: false)
    }

    func showCharacterDetails(for character: Character) {
        let detailsViewController = dependencyContainer.makeCharacterDetailsViewController(character: character, coordinator: self)
        detailsViewController.coordinator = self
        navigationController.pushViewController(detailsViewController, animated: true)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
