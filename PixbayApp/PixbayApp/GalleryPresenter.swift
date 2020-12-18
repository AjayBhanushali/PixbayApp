//
//  GalleryPresenter.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

final class GalleryPresenter: GalleryModuleInput {
    
    var photos: [Photo]? = []
    var searchText = ""
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
    func showRecentSearchResults() {
        
        if let recentSearches = DataBaseUtils.shared.fetchAllSearchText() {
            guard !recentSearches.isEmpty else { return }
            if galleryViewModel == nil {
                galleryViewModel = GalleryViewModel(urlList: [])
            }
            galleryViewModel.recentSearches = recentSearches
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                view?.showRecentSearches(with: self.galleryViewModel)
            }
        }
    }
    
    func searchPhotos(matching imageName: String) {
        searchText = imageName
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
        photos = nil
        view?.resetViews()
        view?.changeViewState(.none)
    }
    
    func didSelectPhoto(at index: Int) {
        guard let photos = photos else { return }
        let imageURLs = photos.compactMap { (photo) -> URL? in
            guard let urlString = photo.largeImageURL, let imageUrl = URL(string: urlString) else {
                return nil
            }
            return imageUrl
        }
        router.showPhotoDetails(with: index, in: imageURLs, for: searchText)
    }
}

extension GalleryPresenter: GalleryInteractorOutput {
    func gallerySearchSuccess(_ galleryPhotos: Gallery) {
        if let hits = galleryPhotos.hits {
            if photos != nil {
                self.photos! += hits
            } else {
                self.photos = hits
            }
        }
        
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

extension GalleryPresenter: GalleryPageVCDelegate {
    func shareMorePhotos(index: Int, callBack: (([URL]?) -> Void)) {
        searchPhotos(matching: searchText)
    }
}
