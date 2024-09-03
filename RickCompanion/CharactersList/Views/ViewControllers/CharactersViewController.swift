//
//  CharactersViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//
import UIKit
import BusinessLayer


class CharactersViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    private let viewModel: CharactersViewModelProtocol
    private let viewControllerNibName = "CharactersViewController"
    
    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        let bundle = Bundle(for: CharactersViewController.self)
        super.init(nibName: viewControllerNibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Characters"

        loadCharacters(page: 1)
    }

    private func loadCharacters(page: Int) {
        viewModel.loadCharacters(page: page) { [weak self] result in
            switch result {
            case .success(let characters):
                // Update UI with characters
                self?.handleCharactersLoaded(characters)
            case .failure(let error):
                // Handle error
                self?.handleError(error)
            }
        }
    }

    private func handleCharactersLoaded(_ characters: CharacterResponse) {
        // Implement UI update logic here
        print("Loaded \(characters.results.count) characters")
    }

    private func handleError(_ error: Error) {
        // Implement error handling logic here
        print("Error loading characters: \(error)")
    }


}
