//
//  AppBuilder.swift
//  PixbayApp
//
//  Created by D2k on 13/12/20.
//

import UIKit

/// AppBuilder should contain task wrt the application
final public class AppBuilder {
    
    /// This method helps to setup Root VC
    /// - Parameter window: UIWindow object
    /// - Returns: default response
    @discardableResult
    func setRootViewController(in window: UIWindow?) -> Bool {
        let vc = ViewController()
        window?.rootViewController = vc
        //NOTE: Following instance method is responsible for bring the window to the front of the screen
        window?.makeKeyAndVisible()
        return true
    }
}
