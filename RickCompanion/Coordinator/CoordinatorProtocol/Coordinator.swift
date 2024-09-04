//
//  Coordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func coordinate(to coordinator: Coordinator)
    func childDidFinish(_ child: Coordinator?)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

protocol ViewCoordinator: Coordinator {
    associatedtype ViewController: UIViewController
    var viewController: ViewController? { get set }
}
