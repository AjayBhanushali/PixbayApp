//
//  PhotoVC.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import UIKit

final class PhotoViewController: UIViewController, PhotoViewInput {

    var presenter: PhotoViewOutput!
    
    fileprivate enum LayoutConstants {
        static let buttonWidth: CGFloat = 50
        static let rightpadding: CGFloat = -20
        static let topPadding: CGFloat = 50
    }
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.setTitle(Strings.close, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.onViewDidLoad()
    }
    
    private func setupViews() {
        view.addSubview(photoImageView)
        view.addSubview(closeButton)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        photoImageView.pinEdgesToSuperview()
        
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: LayoutConstants.rightpadding).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.topPadding).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: LayoutConstants.buttonWidth).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: LayoutConstants.buttonWidth).isActive = true
    }
    
    func showPhoto(using imageURL: URL) {
        ImageDownloader.shared.downloadImage(withURL: imageURL, size: view.bounds.size) { [weak self] (image, _, _, error) in
            DispatchQueue.main.async {
                guard let photoImageView = self?.photoImageView, let image = image else {
                    return
                }
                photoImageView.fadeTransition(with: image)
            }
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIButton) {
        presenter.didTapOnClose()
    }
}
