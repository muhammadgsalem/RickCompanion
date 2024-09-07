//
//  DependencyContainerProtocol.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import DataRepository

/// Protocol defining the contract for the app's dependency container.
protocol DependencyContainerProtocol {
    // MARK: - View Models
    func makeCharactersViewModel() -> CharactersViewModelProtocol
    
    // MARK: - View Controllers
    func makeCharactersViewController(coordinator: CharactersCoordinator, imageLoadingService: ImageCacheService) -> CharactersViewController
    
    // MARK: - Views
    func makeCharacterCellView(character: Character?, imageLoadingService: ImageCacheService?) -> CharacterCellView
    func makeFilterViewWrapper() -> FilterViewWrapper
    
    // MARK: - Detail Views
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator, imageLoadingService: ImageCacheService) -> CharacterDetailsViewController
    func makeCharacterDetailsView(character: Character, imageLoadingService: ImageCacheService, onBackActionSelected: @escaping () -> Void) -> CharacterDetailsView
    
    // MARK: - Services
    func makeImageCache() -> ImageCacheService
    func makeMemoryCache() -> MemoryCacheService
    func makeDiskCache() -> DiskCacheService
}
