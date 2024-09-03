//
//  AppDelegate.swift
//  RickCompanion
//
//  Created by Jimmy on 02/09/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the main window
        window = UIWindow(frame: UIScreen.main.bounds)

        // Create the navigation controller that will be used by the coordinator
        let navigationController = UINavigationController()

        // Initialize the main coordinator with the navigation controller
        let dependencyContainer = DependencyContainer.makeDefault()
        mainCoordinator = MainCoordinator(navigationController: navigationController, dependencyContainer: dependencyContainer)

        // Start the coordinator
        mainCoordinator?.start()

        // Set the root view controller of the window to the navigation controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

