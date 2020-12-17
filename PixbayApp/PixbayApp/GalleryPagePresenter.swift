//
//  GalleryPagePresenter.swift
//  PixbayApp
//
//  Created by D2k on 17/12/20.
//

import Foundation

class GalleryPagePresenter: GalleryPageModuleInput {
    weak var view: GalleryPageViewInput?
    
    var interactor: GalleryPageInteractorInput!
    var galleryViewModel: GalleryViewModel!
    var imageURLs: [URL]?
    var searchText: String
    var currentIndex: Int = 0
    var pageNumber = Constants.defaultPageNum
    
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
    init(with imageUrls: [URL], for _searchText: String, _currentIndex: Int) {
        currentIndex = _currentIndex
        imageURLs = imageUrls
        searchText = _searchText
        totalPages = imageUrls.count/Constants.defaultPageSize
    }
}

extension GalleryPagePresenter: GalleryPageViewOutput {
    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNumber <= totalPages
    }
    
    func onViewDidLoad() {
        guard let imageURLs = imageURLs else { return }
        galleryViewModel = GalleryViewModel(urlList: imageURLs)
        DispatchQueue.main.async { [unowned self] in
            self.view?.displayImages(with: self.galleryViewModel, _currentIndex: self.currentIndex)
        }
    }
    
    func findMorePhotos() {
        guard isMoreDataAvailable else { return }
        pageNumber += 1
        interactor.loadPhotos(matching: searchText, pageNum: pageNumber)
    }
}

extension GalleryPagePresenter: GalleryPageInteractorOutput {
    func gallerySearchSuccess(_ galleryPhotos: Gallery) {
        
        guard let photosUrlList = galleryPhotos.hits?.compactMap({ (photo) -> URL? in
            guard let urlString = photo.largeImageURL, let imageUrl = URL(string: urlString) else {
                return nil
            }
            return imageUrl
        }) else { return }
        
        let previousCount = totalCount
        totalCount += photosUrlList.count
        totalPages = (galleryPhotos.total ?? 0)/Constants.defaultPageSize
        galleryViewModel.appendPhotodUrlList(with: photosUrlList)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertImages(with: self.galleryViewModel, at: indexPaths)
        }
    }
    
    func gallerySearchError(_ error: NetworkError) {
        DispatchQueue.main.async {
//            self.view?.changeViewState(.error(error.description))
        }
    }
}
