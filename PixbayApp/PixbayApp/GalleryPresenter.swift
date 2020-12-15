//
//  GalleryPresenter.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

final class GalleryPresenter: GalleryModuleInput {
    
    weak var view: GalleryViewInput?
    var interactor: GalleryInteractorInput!
    var router: GalleryRouterInput!
    
    var galleryViewModel: GalleryViewModel!
    
    var pageNumber = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
    fileprivate func insertMorePhotos(with photosUrlList: [URL]) {
        let previousCount = totalCount
        totalCount += photosUrlList.count
        galleryViewModel.appendPhotodUrlList(with: photosUrlList)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertImages(with: self.galleryViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }
}

extension GalleryPresenter: GalleryViewOutput {
    func searchPhotos(matching imageName: String) {
        guard isMoreDataAvailable else { return }
        view?.changeViewState(.loading)
        pageNumber += 1
        interactor.loadPhotos(matching: imageName, pageNum: pageNumber)
    }
    
    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNumber < totalPages
    }
    
    func clearData() {
        pageNumber = Constants.defaultPageNum
        totalCount = Constants.defaultTotalCount
        totalPages = Constants.defaultTotalCount
        galleryViewModel = nil
        view?.resetViews()
        view?.changeViewState(.none)
    }
    
    func didSelectPhoto(at index: Int) {
        let imageUrl = galleryViewModel.photoUrlAt(index)
        router.showPhotoDetails(with: imageUrl)
    }
}

extension GalleryPresenter: GalleryInteractorOutput {
    func gallerySearchSuccess(_ galleryPhotos: Gallery) {
        guard let photosUrlList = galleryPhotos.hits?.compactMap({ (photo) -> URL? in
            guard let urlString = photo.previewURL, let imageUrl = URL(string: urlString) else {
                return nil
            }
            return imageUrl
        }) else { return }
        
        if totalCount == Constants.defaultTotalCount {
            galleryViewModel = GalleryViewModel(urlList: photosUrlList)
            totalCount = galleryPhotos.hits?.count ?? 0
            totalPages = (galleryPhotos.total ?? 0)/totalCount
            DispatchQueue.main.async { [unowned self] in
                self.view?.displayImages(with: self.galleryViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMorePhotos(with: photosUrlList)
        }
    }
    
    func gallerySearchError(_ error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.description))
        }
    }
}
