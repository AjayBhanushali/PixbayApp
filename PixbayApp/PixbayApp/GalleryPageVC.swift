//
//  GalleryPageVC.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 17/12/20.
//

import UIKit

protocol GalleryPageVCDelegate: class {
    func shareMorePhotos(index: Int, callBack:(([URL]?)->Void))
}

final class GalleryPageVC: UIViewController {
    
    var presenter: GalleryPageViewOutput!
    var galleryViewModel: GalleryViewModel!
    var pageViewController = UIPageViewController()
    var index = 0
    
    var currentViewController: PhotoViewController {
        return self.pageViewController.viewControllers![0] as! PhotoViewController
    }
    
    var currentIndex = 0
    var nextIndex: Int?
    weak var delegate: GalleryPageVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    private func prepareView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        add(pageViewController)
        pageViewController.view.frame = view.frame
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        presenter.onViewDidLoad()
    }
}

extension GalleryPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 {
            return nil
        }
        
        let vc = PhotoViewController()
        vc.index = currentIndex - 1
        vc.imageURL = galleryViewModel.photosUrlList[vc.index]
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == (galleryViewModel.photosUrlList.count - 1) {
            presenter.findMorePhotos()
            return nil
        }
        
        let vc = PhotoViewController()
        vc.index = currentIndex + 1
        vc.imageURL = galleryViewModel.photosUrlList[vc.index]
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PhotoViewController else {
            return
        }
        self.nextIndex = nextVC.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && self.nextIndex != nil) {
            
            self.currentIndex = self.nextIndex!
        }
        self.nextIndex = nil
    }
    
}

extension GalleryPageVC: GalleryPageViewInput {
    func displayImages(with viewModel: GalleryViewModel, _currentIndex: Int) {
        galleryViewModel = viewModel
        currentIndex = _currentIndex
        let vc = PhotoViewController()
        vc.index = self.currentIndex
        vc.imageURL = galleryViewModel.photosUrlList[self.currentIndex]
        let viewControllers = [vc]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    func insertImages(with viewModel: GalleryViewModel, at indexPaths: [IndexPath]) {
        self.currentIndex += 1
        galleryViewModel = viewModel
        let vc = PhotoViewController()
        vc.index = self.currentIndex
        vc.imageURL = galleryViewModel.photosUrlList[self.currentIndex]
        let viewControllers = [vc]
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
}
