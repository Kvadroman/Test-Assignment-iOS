//
//  WindowCoordinator.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation

public protocol WindowCoordinatorType: BaseCoordinatorType {
    var router: WindowRouterType { get }
}

open class WindowCoordinator<DeepLinkType>: NSObject, WindowCoordinatorType {
    
    public var childCoordinators: [PresentableCoordinator<DeepLinkType>] = []
    
    open var router: WindowRouterType
    
    public init(router: WindowRouterType) {
        self.router = router
        super.init()
    }
    
    open func start() { start(with: nil) }
    open func start(with link: DeepLinkType?) {}
    
    public func addChild(_ coordinator: Coordinator<DeepLinkType>) {
        childCoordinators.append(coordinator)
    }
    
    public func removeChild(_ coordinator: Coordinator<DeepLinkType>?) {
        guard let coordinator, let index = childCoordinators.firstIndex(of: coordinator) else {
            return
        }
        childCoordinators.remove(at: index)
    }
}
