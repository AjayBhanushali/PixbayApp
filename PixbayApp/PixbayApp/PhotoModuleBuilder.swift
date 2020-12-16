//
//  PhotoModuleBuilder.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

protocol PhotoModuleBuilderProtocol {
    func buildModule(with imageUrl: URL) -> PhotoViewController
}

final class PhotoModuleBuilder: PhotoModuleBuilderProtocol {
    
    func buildModule(with imageUrl: URL) -> PhotoViewController {
        
        let detailViewController = PhotoViewController()
        let presenter = PhotoPresenter(imageUrl: imageUrl)
        let router = PhotoRouter()
        
        presenter.view = detailViewController
        presenter.router = router
        
        detailViewController.presenter = presenter
        router.viewController = detailViewController
        
        return detailViewController
    }
}
