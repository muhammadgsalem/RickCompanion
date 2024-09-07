//
//  CharactersTableViewManager.swift
//  RickCompanion
//
//  Created by Jimmy on 06/09/2024.
//

import UIKit
import DataRepository

/// This class is responsible for handling the TableView UITableViewDataSource, UITableViewDelegate and UITableViewDataSourcePrefetching to keep the VC clean.
class CharactersTableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    private let viewModel: CharactersViewModelProtocol
    private let coordinator: CharactersCoordinator
    private let imageLoadingService: ImageCacheService
    
    init(viewModel: CharactersViewModelProtocol, coordinator: CharactersCoordinator, imageLoadingService: ImageCacheService) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.imageLoadingService = imageLoadingService
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character, imageLoadingService: imageLoadingService)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        coordinator.showCharacterDetails(character)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.map { $0.row }.max() ?? 0
        if maxIndex >= viewModel.characters.count - 1 {
            Task {
                await viewModel.loadCharacters()
            }
        }
    }
}
