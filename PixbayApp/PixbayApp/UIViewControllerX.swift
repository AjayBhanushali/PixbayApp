//
//  UIViewControllerX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 11/10/20.
//  
//

import UIKit

extension UIViewController {
    
    /// Show Alert on the self
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - retryAction: closure for retry
    func showAlert(title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if retryAction != nil {
            alertViewController.addAction(UIAlertAction(title: Strings.cancel, style: .default))
        }
        let title = (retryAction == nil) ? Strings.ok : Strings.retry
        alertViewController.addAction(UIAlertAction(title: title, style: .default) { _ in
            retryAction?()
        })
        present(alertViewController, animated: true)
    }
}
