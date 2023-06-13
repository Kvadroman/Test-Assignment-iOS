//
//  WindowsRouter.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

public protocol WindowRouterType: AnyObject {
    var window: UIWindow { get }
    init(window: UIWindow)
    func setRootModule(_ module: Presentable)
}

final public class WindowRouter: NSObject, WindowRouterType {

    public unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
        super.init()
    }

    public func setRootModule(_ module: Presentable) {
        let viewController = module.toPresentable()
        window.rootViewController = viewController
    }
}
