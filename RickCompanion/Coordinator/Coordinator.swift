//
//  Coordinator.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
    func popViewController()
    func popToRootViewController()
    func dismissViewController()
}
