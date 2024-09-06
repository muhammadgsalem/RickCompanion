//
//  CharacterDetailsViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 04/09/2024.
//

import DataRepository
import SwiftUI
import UIKit

class CharacterDetailsViewController: UIViewController {
    weak var coordinator: CharacterDetailCoordinator?
    private let character: Character
    private let imageLoadingService: ImageCacheService

    init(character: Character, coordinator: CharacterDetailCoordinator, imageLoadingService: ImageCacheService) {
        self.character = character
        self.coordinator = coordinator
        self.imageLoadingService = imageLoadingService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            coordinator?.finish()
        }
    }
    
    private func setupSwiftUIView() {
        let characterDetailsView = DependencyContainer.shared.makeCharacterDetailsView(character: character, imageLoadingService: imageLoadingService) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pop()
        }
        
        let hostingController = UIHostingController(rootView: characterDetailsView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
