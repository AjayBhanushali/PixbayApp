//
//  GalleryPageBuilder.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 18/12/20.
//

import Foundation

protocol GalleryPageBuilderProtocol: AnyObject {
    func buildModule(using imageUrls: [URL], for searchText: String, currentIndex: Int) -> GalleryPageVC
}


final class GalleryPageModuleBuilder: GalleryPageBuilderProtocol {
    
    func buildModule(using imageUrls: [URL], for searchText: String, currentIndex: Int) -> GalleryPageVC {
        let viewController = GalleryPageVC()
        let presenter = GalleryPagePresenter(with: imageUrls, for: searchText, _currentIndex: currentIndex)
        let network = NetworkAPI()
        let interactor = GalleryPageIneractor(network: network)
        
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
}
