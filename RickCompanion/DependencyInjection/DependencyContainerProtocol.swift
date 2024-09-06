//
//  DependencyContainerProtocol.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import DataRepository

protocol DependencyContainerProtocol {
    
    
    func makeCharactersViewModel() -> CharactersViewModelProtocol
    func makeCharactersViewController(coordinator: CharactersCoordinator, imageLoadingService: ImageCacheService) -> CharactersViewController
    func makeCharacterCellView(character: Character?, imageLoadingService: ImageCacheService?) -> CharacterCellView
    
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator, imageLoadingService: ImageCacheService) -> CharacterDetailsViewController
    func makeCharacterDetailsView(character: Character, imageLoadingService: ImageCacheService, onBackActionSelected: @escaping () -> Void) -> CharacterDetailsView
    
    
    
    func makeImageCache() -> ImageCacheService
    func makeMemoryCache() -> MemoryCacheService
    func makeDiskCache() -> DiskCacheService
    
}
