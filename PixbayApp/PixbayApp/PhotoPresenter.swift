//
//  PhotoPresenter.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

final class PhotoPresenter: PhotoModuleInput, PhotoViewOutput {
    
    var view: PhotoViewInput?
    var router: PhotoRouterInput!
    
    var imageUrl: URL
    
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    func onViewDidLoad() {
        self.view?.showActivityLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else {
                return
            }
            self.view?.showPhoto(using: self.imageUrl)
            self.view?.hideActivityLoader()
        }
    }
    
    func didTapOnClose() {
        router.dismiss()
    }
}
