//
//  PhotoRouter.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import UIKit

final class PhotoRouter: PhotoRouterInput {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
