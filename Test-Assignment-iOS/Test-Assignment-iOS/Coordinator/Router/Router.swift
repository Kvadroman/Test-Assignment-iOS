//
//  Router.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

public protocol RouterType: AnyObject, Presentable {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    ///Pushes module or vc into the navigationController stack
    func push(_ module: Presentable, animated: Bool)
    ///Pops the last controller or module in the navigationController stack
    func popModule(animated: Bool, completion: (() -> Void)?)
    ///Sets the root controller in navigationController
    func setRootModule(_ module: Presentable, animated: Bool)
}

final public class Router: NSObject, RouterType, UINavigationControllerDelegate {
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.isTranslucent = true
        super.init()
        self.navigationController.delegate = self
    }
    
    public func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    public func push(_ module: Presentable, animated: Bool = true) {
        let controller = module.toPresentable()
        // Avoid pushing UINavigationController onto stack
        guard controller is UINavigationController == false else {
            return
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func popModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.popViewController(animated: animated)
        completion?()
    }
    
    public func setRootModule(_ module: Presentable, animated: Bool = false) {
        navigationController.setViewControllers([module.toPresentable()], animated: animated)
    }
    
    // MARK: Presentable
    public func toPresentable() -> UIViewController {
        navigationController
    }
}

extension RouterType {
    func popModule(animated: Bool) {
        popModule(animated: animated, completion: nil)
    }
}

