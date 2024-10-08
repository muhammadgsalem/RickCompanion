//
//  BusinessLayerDIContainer.swift
//  BusinessLayer
//
//  Created by Jimmy on 04/09/2024.
//

import Foundation
import DataRepository

public final class BusinessLayerDIContainer {
    public static let shared = BusinessLayerDIContainer()
    
    private let dataRepositoryDIContainer: DataRepositoryDIContainer
    
    private init(dataRepositoryDIContainer: DataRepositoryDIContainer = .shared) {
        self.dataRepositoryDIContainer = dataRepositoryDIContainer
    }
    
    public func makeFetchCharactersUseCase() -> FetchCharactersUseCaseProtocol {
        FetchCharactersUseCase(characterRepository: dataRepositoryDIContainer.makeCharacterRepository())
    }
}
