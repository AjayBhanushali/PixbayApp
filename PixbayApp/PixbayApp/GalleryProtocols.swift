//
//  GalleryProtocols.swift
//  PixbayApp
//
//  Created by D2k on 15/12/20.
//

import Foundation
import UIKit


/// Basic View functionallies
protocol BaseViewInput: AnyObject {
    /// Show Loader
    func showActivityLoader()
    
    /// Hide Loader
    func hideActivityLoader()
}

/// Using default implement for conforming types of UIViewController
extension BaseViewInput where Self: UIViewController {
    func showActivityLoader() {
        view.showSpinner()
    }
    
    func hideActivityLoader() {
        view.hideSpinner()
    }
}



/// Set of properties, task View is responsible for
protocol GalleryViewInput: BaseViewInput {
    /// Presenter with Object of ViewOutput for encapsulating the functionalities
    var presenter: GalleryViewOutput! { get set }
    /// To handle the state of the view
    func changeViewState(_ state: ViewState)
    
    /// Display items
    func displayImages(with viewModel: GalleryViewModel)
    
    /// Append items
    func insertImages(with viewModel: GalleryViewModel, at indexPaths: [IndexPath])
    
    /// Reset the list
    func resetViews()
}

//MARK: Presenter
protocol GalleryModuleInput: AnyObject {
    /// View with object of inputVIew
    var view: GalleryViewInput? { get set }
    
    /// Interactor with object of InputInteractor
    var interactor: GalleryInteractorInput! { get set }
    
    /// To direct another view
    var router: GalleryRouterInput! { get set }
}

protocol GalleryViewOutput: AnyObject {
    func searchPhotos(matching imageName: String)
    var isMoreDataAvailable: Bool { get }
    func clearData()
    func didSelectPhoto(at index: Int)
}

protocol GalleryInteractorOutput: AnyObject  {
    func gallerySearchSuccess(_ galleryPhotos: Gallery)
    func gallerySearchError(_ error: NetworkError)
}


//MARK: InteractorInput
protocol GalleryInteractorInput: AnyObject {
    var presenter: GalleryInteractorOutput? { get set }
    func loadPhotos(matching imageName: String, pageNum: Int)
}

//MARK: Router
protocol GalleryRouterInput: AnyObject {
    func showPhotoDetails(with imageUrl: URL)
}


enum GalleryAPI: NetworkAPIEndPoint, URLRequestable {
    
    case search(query: String, page: Int)

}

extension GalleryAPI {
    
    var baseURL: URL {
        return URL(string: APIConstants.galleryBaseURL)!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api"
    }
    
    var parameters: [String : Any] {
        switch self {
        case let .search(query, page):
            return [
                "key": APIConstants.galleryAPIKey,
                "q": query,
                "image_type": "photo",
                "page": page,
                "per_page": Constants.defaultPageSize
            ]
        }
    }
    
}
