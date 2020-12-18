//
//  SearchVC.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 16/12/20.
//

import UIKit

protocol GallerySearchDelegate: AnyObject {
    func didTapSearchBar(withText searchText: String)
}

final class SearchVC: UIViewController {

    weak var searchDelegate: GallerySearchDelegate?
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var recentSearches: [String] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.myTableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(myTableView)
        myTableView.pinEdgesToSuperview()
        myTableView.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
    }

    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            if let recentSearches = DataBaseUtils.shared.fetchAllSearchText() {
                guard !recentSearches.isEmpty else { return }
                self?.recentSearches = recentSearches
            }
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        defer {
            fetchData()
        }
        return true
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

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as! RecentSearchCell
        cell.title = recentSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDelegate?.didTapSearchBar(withText: recentSearches[indexPath.row])
    }
}
