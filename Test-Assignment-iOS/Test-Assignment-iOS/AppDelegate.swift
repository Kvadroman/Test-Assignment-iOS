//
//  AppDelegate.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let container = AppDependencyContainer()
    var window: UIWindow? 
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Create appCoordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = container.makeCoordinator()
        window?.rootViewController = appCoordinator.toPresentable()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        appCoordinator.start(with: .cards) 
        return true
    }
}

