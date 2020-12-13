//
//  UIImageViewX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 11/10/20.
//  
//

import UIKit

extension UIImageView {
    
    /// Load Image into imageView from the given imageUrl using ImageDownloader
    /// - Parameters:
    ///   - imageURL: URL for image
    ///   - placeholder: Placeholder image
    ///   - size: Size of the image(mostly same as ImageView)
    ///   - indexPath: IndexPath if available
    func loadImage(with imageURL: URL, placeholder: UIImage? = UIImage(color: .black), size: CGSize, indexPath: IndexPath?) {
        self.image = placeholder
        ImageDownloader.shared.downloadImage(
            withURL: imageURL,
            size: size,
            indexPath: indexPath,
            completion: { [weak self] (image: UIImage?, resultIndexPath: IndexPath?, url: URL, error: Error?) in
                if let self = self, let kIndexPath = resultIndexPath, indexPath == kIndexPath, imageURL.absoluteString == url.absoluteString {
                    DispatchQueue.main.async {
                        if let downloadedImage = image {
                            self.fadeTransition(with: downloadedImage)
                        }
                    }
                }
        })
    }
    
    //MARK: Fade transition Animation
    /// Show Image with an animation
    /// - Parameters:
    ///   - image: UIImage which needs to set
    ///   - duration: Animation time
    ///   - completion: completion handler if required
    func fadeTransition(with image: UIImage?, duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: completion)
    }
}
