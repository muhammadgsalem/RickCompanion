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

final class DependencyContainer: DependencyContainerProtocol {
    static let shared = DependencyContainer()
    
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
    
    @MainActor func makeCharactersViewModel() -> CharactersViewModelProtocol {
        CharactersViewModel(fetchCharactersUseCase: businessLayerDIContainer.makeFetchCharactersUseCase())
    }
    
    @MainActor func makeCharactersViewController(coordinator: CharactersCoordinator, imageLoadingService: ImageCacheService) -> CharactersViewController {
        let viewModel = makeCharactersViewModel()
        let filterViewWrapper = makeFilterViewWrapper()
        return CharactersViewController(coordinator: coordinator,
                                        viewModel: viewModel,
                                        imageLoadingService: imageLoadingService,
                                        filterViewWrapper: filterViewWrapper)
    }
    
    func makeFilterViewWrapper() -> FilterViewWrapper {
        FilterViewWrapper()
    }
    
    func makeCharacterCellView(character: Character?, imageLoadingService: ImageCacheService?) -> CharacterCellView {
        CharacterCellView(character: character, imageLoadingService: imageLoadingService)
    }
    
    func makeCharacterDetailsViewController(character: Character, coordinator: CharacterDetailCoordinator, imageLoadingService: ImageCacheService) -> CharacterDetailsViewController {
        let imageLoadingService = makeImageCache()
        return CharacterDetailsViewController(character: character,
                                              coordinator: coordinator,
                                              imageLoadingService: imageLoadingService)
    }
    
    func makeCharacterDetailsView(character: Character, imageLoadingService: ImageCacheService, onBackActionSelected: @escaping () -> Void) -> CharacterDetailsView {
        CharacterDetailsView(character: character,
                             onBackActionSelected: onBackActionSelected,
                             imageLoadingService: imageLoadingService)
    }
    
    func makeImageCache() -> ImageCacheService {
        ImageCache(memoryCache: makeMemoryCache(), diskCache: makeDiskCache())
    }
    
    func makeMemoryCache() -> MemoryCacheService {
        MemoryCache()
    }
    
    func makeDiskCache() -> DiskCacheService {
        DiskCache()
    }
}
