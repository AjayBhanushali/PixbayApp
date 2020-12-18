//
//  GalleryInteractor.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 16/12/20.
//

import Foundation

final class GalleryIneractor: GalleryInteractorInput {

    let network: NetworkService
    weak var presenter: GalleryInteractorOutput?
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func loadPhotos(matching imageName: String, pageNum: Int) {
        let endPoint = GalleryAPI.search(query: imageName, page: pageNum)
        network.dataRequest(endPoint, objectType: Gallery.self) { [weak self] (result: Result<Gallery, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                if response.total != nil, response.total! > 0 {
                    self.presenter?.gallerySearchSuccess(response)
                } else {
                    self.presenter?.gallerySearchError(NetworkError.emptyData)
                }
            case let .failure(error):
                self.presenter?.gallerySearchError(error)
            }
        }
    }
}
