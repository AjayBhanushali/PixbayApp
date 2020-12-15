//
//  SearchVC.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import UIKit

protocol GallerySearchDelegate: AnyObject {
    func didTapSearchBar(withText searchText: String)
}

final class SearchVC: UIViewController, UISearchBarDelegate {

    weak var searchDelegate: GallerySearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchBar.text = text
        searchBar.resignFirstResponder()
        searchDelegate?.didTapSearchBar(withText: text)
    }
}