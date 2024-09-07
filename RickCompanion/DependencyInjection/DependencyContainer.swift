//
//  DefaultDependencyContainer.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import APIGate
import BusinessLayer
import DataRepository
import Foundation

/// The main dependency container for the application.
/// This class is responsible for creating and managing all dependencies across the app.
final class DependencyContainer: DependencyContainerProtocol {
    // Singleton instance
    static let shared = DependencyContainer()
    
    // Dependencies from other modules
    private let apiGateDIContainer: APIGateDIContainer
    private let dataRepositoryDIContainer: DataRepositoryDIContainer
    private let businessLayerDIContainer: BusinessLayerDIContainer
    
    private init(
        apiGateDIContainer: APIGateDIContainer = .shared,
        dataRepositoryDIContainer: DataRepositoryDIContainer = .shared,
        businessLayerDIContainer: BusinessLayerDIContainer = .shared
    ) {
        self.apiGateDIContainer = apiGateDIContainer
        self.dataRepositoryDIContainer = dataRepositoryDIContainer
        self.businessLayerDIContainer = businessLayerDIContainer
    }
    
    // MARK: - View Models
    
    /// Creates and returns a new instance of CharactersViewModel.
    @MainActor func makeCharactersViewModel() -> CharactersViewModelProtocol {
        CharactersViewModel(fetchCharactersUseCase: businessLayerDIContainer.makeFetchCharactersUseCase())
    }
    
    // MARK: - View Controllers
    
    /// Creates and returns a new instance of CharactersViewController.
    @MainActor func makeCharactersViewController(coordinator: CharactersCoordinator, imageLoadingService: ImageCacheService) -> CharactersViewController {
        let viewModel = makeCharactersViewModel()
        let filterViewWrapper = makeFilterViewWrapper()
        return CharactersViewController(coordinator: coordinator,
                                        viewModel: viewModel,
                                        imageLoadingService: imageLoadingService,
                                        filterViewWrapper: filterViewWrapper)
    }
    
    // MARK: - Views
    
    /// Creates and returns a new instance of FilterViewWrapper.
    func makeFilterViewWrapper() -> FilterViewWrapper {
        FilterViewWrapper()
    }
    
    /// Creates and returns a new instance of CharacterCellView.
    func makeCharacterCellView(character: Character?, imageLoadingService: ImageCacheService?) -> CharacterCellView {
        CharacterCellView(character: character, imageLoadingService: imageLoadingService)
    }
    
    // MARK: - Detail Views
    
    /// Creates and returns a new instance of CharacterDetailsViewController.
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator, imageLoadingService: ImageCacheService) -> CharacterDetailsViewController {
        let imageLoadingService = makeImageCache()
        return CharacterDetailsViewController(character: character,
                                              coordinator: coordinator,
                                              imageLoadingService: imageLoadingService)
    }
    
    /// Creates and returns a new instance of CharacterDetailsView.
    func makeCharacterDetailsView(character: Character, imageLoadingService: ImageCacheService, onBackActionSelected: @escaping () -> Void) -> CharacterDetailsView {
        CharacterDetailsView(character: character,
                             onBackActionSelected: onBackActionSelected,
                             imageLoadingService: imageLoadingService)
    }
    
    // MARK: - Services
    
    /// Creates and returns a new instance of ImageCacheService.
    func makeImageCache() -> ImageCacheService {
        ImageCache(memoryCache: makeMemoryCache(), diskCache: makeDiskCache())
    }
    
    /// Creates and returns a new instance of MemoryCacheService.
    func makeMemoryCache() -> MemoryCacheService {
        MemoryCache()
    }
    
    /// Creates and returns a new instance of DiskCacheService.
    func makeDiskCache() -> DiskCacheService {
        DiskCache()
    }
}
