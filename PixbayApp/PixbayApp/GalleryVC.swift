//
//  GalleryVC.swift
//  PixbayApp
//
//  Created by D2k on 16/12/20.
//

import UIKit

final class GalleryVC: UIViewController, GalleryViewInput, GallerySearchDelegate {
    var presenter: GalleryViewOutput!
    var viewState: ViewState = .none
    var galleryViewModel: GalleryViewModel?
    var searchText = ""
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing = Constants.defaultSpacing
        let itemSize: CGFloat = (UIScreen.main.bounds.width - (Constants.numberOfColumns - spacing) - 2) / Constants.numberOfColumns
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchResultsUpdater = nil
        controller.searchBar.placeholder = Strings.searchPlaceHolder
        controller.searchBar.delegate = self
        return controller
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: ViewController Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appBackground()
        self.title = "PixBay"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        themeViews()
    }
    
    // MARK: Private Functions
    
    private func setupViews() {
        configureCollectionView()
        configureSearchController()
        configureTableView()
    }
    
    private func themeViews() {
        view.backgroundColor = .appBackground()
        collectionView.backgroundColor = .appBackground()
    }
    
    // MARK: configureSearchController
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    //MARK: ConfigureCollectionView
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperview()
        collectionView.registerCell(ImageCell.self)
        collectionView.register(FooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.pinEdgesToSuperview()
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
    }
    //MARK: GalleryViewInput
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if galleryViewModel == nil {
                showActivityLoader()
            }
        case .content:
            hideActivityLoader()
        case .error(let message):
            hideActivityLoader()
            showAlert(title: Strings.error, message: message, retryAction: { [unowned self] in
                self.presenter.searchPhotos(matching: self.searchText)
            })
        default:
            break
        }
    }
    
    func showRecentSearches(with viewModel: GalleryViewModel) {
        galleryViewModel = viewModel
        tableView.isHidden = false
        view.bringSubviewToFront(tableView)
        tableView.reloadData()
    }
    
    func displayImages(with viewModel: GalleryViewModel) {
        tableView.isHidden = true
        galleryViewModel = viewModel
        collectionView.reloadData()
    }
    
    func insertImages(with viewModel: GalleryViewModel, at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            self.galleryViewModel = viewModel
            self.collectionView.insertItems(at: indexPaths)
        })
    }
    
    func resetViews() {
        searchController.searchBar.text = nil
        galleryViewModel = nil
        collectionView.reloadData()
    }
    
    func didTapSearchBar(withText searchText: String) {
        searchController.isActive = false
        guard !searchText.isEmpty || searchText != self.searchText else { return }
        presenter.clearData()
        
        self.searchText = searchText
        searchController.searchBar.text = searchText
        ImageDownloader.shared.cancelAll()
        presenter.searchPhotos(matching: searchText)
    }
    
    func didStartEditing() {
        presenter.showRecentSearchResults()
    }
    
    func didCancelEditing() {
        tableView.isHidden = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
           themeViews()
        }
    }
}


//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.galleryViewModel, !viewModel.isEmpty else {
            return 0
        }
        return viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageCell
        guard let viewModel = galleryViewModel else {
            return cell
        }
        let imageURL = viewModel.photoUrlAt(indexPath.item)
        cell.configure(imageURL: imageURL, size: collectionViewLayout.itemSize, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = galleryViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.totalCount - 1) else {
            return
        }
        presenter.searchPhotos(matching: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = galleryViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.totalCount - 1) else {
            return
        }
        let imageURL = viewModel.photoUrlAt(indexPath.row)
        ImageDownloader.shared.changeDownloadPriority(for: imageURL)
    }
    
    //MARK: UICollectionViewFooter
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewState == .loading && galleryViewModel != nil {
            return CGSize(width: Constants.screenWidth, height: 50)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,  at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as FooterView
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectPhoto(at: indexPath.item)
    }
}

extension GalleryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryViewModel?.recentSearches.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as! RecentSearchCell
        if let searchText = galleryViewModel?.recentSearches[indexPath.row] {
            cell.title = searchText
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let searchText = galleryViewModel?.recentSearches[indexPath.row] {
            tableView.isHidden = true
            presenter.clearData()
            searchController.isActive = false
            presenter.searchPhotos(matching: searchText)
            searchController.searchBar.text = searchText
        }
        
    }
}

extension GalleryVC: UISearchBarDelegate {


    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        didStartEditing()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didCancelEditing()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        didStartEditing()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchBar.text = text
        searchBar.resignFirstResponder()
        didTapSearchBar(withText: text)
    }
}
