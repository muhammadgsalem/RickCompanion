//
//  MainCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer

    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        let charactersViewController = dependencyContainer.makeCharactersViewController()
        navigationController.pushViewController(charactersViewController, animated: false)
    }

//    func showCharacterDetail(for character: Character) {
//        let detailViewModel = dependencyContainer.makeCharacterDetailViewModel(character: character)
//        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
//        navigationController.pushViewController(detailViewController, animated: true)
//    }
}
