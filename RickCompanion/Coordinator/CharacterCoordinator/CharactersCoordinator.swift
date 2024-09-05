//
//  CharactersCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import UIKit
import DataRepository

class CharactersCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @MainActor func start() {
        let charactersVC = DependencyContainer.shared.makeCharactersViewController(coordinator: self)
        navigationController.pushViewController(charactersVC, animated: false)
    }
    
    func showCharacterDetails(_ character: Character) {
        let detailCoordinator = CharacterDetailCoordinator(navigationController: navigationController, character: character)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
}
