//
//  CharacterDetailCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import UIKit
import DataRepository

class CharacterDetailCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    let character: Character
    
    init(navigationController: UINavigationController, character: Character) {
        self.navigationController = navigationController
        self.character = character
    }
    
    func start() {
        let imageLoadingService = DependencyContainer.shared.makeImageCache()
        let detailVC = DependencyContainer.shared.makeCharacterDetailsViewController(character: character, coordinator: self, imageLoadingService: imageLoadingService)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        // Implementation not needed for this coordinator as it doesn't have child coordinators
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
