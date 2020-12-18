//
//  PhotoVC.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 16/12/20.
//

import UIKit

final class PhotoViewController: UIViewController, BaseViewInput {

    var index: Int = 0
    var imageURL: URL?
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(photoImageView)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
        photoImageView.pinEdgesToSuperview()
        if let imageURL = imageURL {
            showPhoto(using: imageURL)
        }
    }
    
    func showPhoto(using imageURL: URL) {
        showActivityLoader()
        ImageDownloader.shared.downloadImage(withURL: imageURL, size: view.bounds.size) { [weak self] (image, _, _, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityLoader()
                guard let image = image else {
                    return
                }
                self.photoImageView.fadeTransition(with: image)
            }
        }
    }
}
