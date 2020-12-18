//
//  GalleryPageProtocols.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 18/12/20.
//

import Foundation

// MARK: View Protocol
protocol GalleryPageViewInput: BaseViewInput {
    var presenter: GalleryPageViewOutput! { get set }
    
    /// Display items
    func displayImages(with viewModel: GalleryViewModel, _currentIndex: Int)
    
    /// Append items
    func insertImages(with viewModel: GalleryViewModel, at indexPaths: [IndexPath])
}

// MARK: Presenter Protocols
protocol GalleryPageModuleInput: AnyObject {
    var view: GalleryPageViewInput? { get set }
    var interactor: GalleryPageInteractorInput! { get set }
}

protocol GalleryPageViewOutput: AnyObject {
    var imageURLs: [URL]? { get set }
    var searchText: String { get set }
    func onViewDidLoad()
    func findMorePhotos()
    var isMoreDataAvailable: Bool { get }
}

protocol GalleryPageInteractorOutput: AnyObject {
    func gallerySearchSuccess(_ galleryPhotos: Gallery)
    func gallerySearchError(_ error: NetworkError)
}

//MARK: Interactor Protocol
protocol GalleryPageInteractorInput: AnyObject {
    var presenter: GalleryPageInteractorOutput? { get set }
    func loadPhotos(matching imageName: String, pageNum: Int)
}

//MARK: Router Protocol
protocol GalleryPageRouterInput: AnyObject {
    
}
