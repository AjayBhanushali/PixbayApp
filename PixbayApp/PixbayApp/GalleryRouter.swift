//
//  GalleryRouter.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import UIKit

final class GalleryRouter: GalleryRouterInput {
   
    weak var viewController: UIViewController?
    weak var delegate: GalleryPageVCDelegate?
    func showPhotoDetails(with currentIndex: Int, in photos: [URL], for searchText: String) {
        let pageVC = GalleryPageModuleBuilder().buildModule(using: photos, for: searchText, currentIndex: currentIndex)
        viewController?.present(pageVC, animated: true)
    }
    
    
}
