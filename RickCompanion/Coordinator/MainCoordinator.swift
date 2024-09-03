//
//  MainCoordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showCharactersList()
    }

    private func showCharactersList() {
        let viewModel = DependencyContainer.shared.makeCharacterViewModel()
        let charactersViewController = CharactersViewController(viewModel: viewModel)
        charactersViewController.coordinator = self
        navigationController.pushViewController(charactersViewController, animated: true)
    }

//    func showCharacterDetail(for character: Character) {
//        let detailViewModel = DependencyContainer.shared.makeCharacterDetailViewModel(character: character)
//        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
//        navigationController.pushViewController(detailViewController, animated: true)
//    }
}
