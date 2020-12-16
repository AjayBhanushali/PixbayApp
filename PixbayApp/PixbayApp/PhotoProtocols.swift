//
//  PhotoProtocols.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import Foundation

// MARK: View Protocol
protocol PhotoViewInput: BaseViewInput {
    var presenter: PhotoViewOutput! { get set }
    func showPhoto(using imageURL: URL)
}

// MARK: Presenter Protocols
protocol PhotoModuleInput: AnyObject {
    var view: PhotoViewInput? { get set }
//    var interactor: PhotoInteractorInput! { get set }
    var router: PhotoRouterInput! { get set }
}

protocol PhotoViewOutput: AnyObject {
    func didTapOnClose()
    func onViewDidLoad()
}

protocol PhotoInteractorOutput: AnyObject {
    
}

//MARK: Interactor Protocol
protocol PhotoInteractorInput: AnyObject {

}

//MARK: Router Protocol
protocol PhotoRouterInput: AnyObject {
    func dismiss()
}
