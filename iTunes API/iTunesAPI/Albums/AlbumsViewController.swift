//
//  AlbumsViewController.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 09.12.2021.
//

import UIKit
import Sugar
import SnapKit
/// ViewController for searching albums in iTunes.
class AlbumsViewController: UIViewController, InterfaceSetupProtocol {

    private let manager = AlbumsManager()
/// Albums in current response.
    var albums: [Album] = [] {
        didSet {
            albumsCollectionView.reloadData()
        }
    }
/// Task for search debounce.
    var searchTask: DispatchWorkItem?
/// Collection view for presenting response.
    private lazy var albumsCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {

        $0.contentInset = UIEdgeInsets(top: Insets.space20,
                                       left: Insets.space20,
                                       bottom: Insets.space20,
                                       right: Insets.space20)
        $0.delegate = self
        $0.dataSource = self
        $0.register(AlbumCollectionViewCell.self,
                    forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        
        $0.backgroundColor = .clear
    }
/// Activity indicator for loading status.
    private let activityIndicator = UIActivityIndicatorView().then {
        $0.style = Constants.activityStyle
        $0.color = .darkGray
    }
/// Search controller.
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.obscuresBackgroundDuringPresentation = false
        $0.hidesNavigationBarDuringPresentation = true
        $0.searchBar.placeholder = "Введите текст..."
        $0.searchBar.showsScopeBar = true
        $0.searchBar.returnKeyType = .done
        $0.searchBar.delegate = self
        $0.searchBar.setImage(UIImage(), for: .search, state: .normal)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupSearchController()
    }

    init(with searchText: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.searchController = nil
        showActivity()
        manager.searchAlbums(searchText) { [weak self] albums, loaded  in
            self?.albums = albums
            if loaded {
                self?.hideActivity()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
        manager.delegate = self
    }
    func commonSetup() {
        addSubviews()
        makeConstraints()
    }
    
    func addSubviews() {
        view.addSubviews(activityIndicator, albumsCollectionView)
    }
    
    func makeConstraints() {
        albumsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.center = view.center
    }
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
/// Shows activity indicator.
    private func showActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        albumsCollectionView.isHidden = true
    }
/// Hides activity indicator.
    private func hideActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        albumsCollectionView.isHidden = false
    }
}
extension AlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier,
                                     for: indexPath) as? AlbumCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.album = albums[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let zero = Insets.zero
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? zero) +
                             (flowayout?.sectionInset.left ?? zero) +
                             (flowayout?.sectionInset.right ?? zero)
        let width: CGFloat = (collectionView.frame.size.width - space) / 3 - Insets.space20
        let height = Constants.cellFontSize * 2 + Insets.space10 * 2 + width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = self.albums[indexPath.item]
        navigationController?.pushViewController(AlbumViewController(album: album),
                                                 animated: false)
    }
}

extension AlbumsViewController: UISearchBarDelegate {
/// Find albums by text.
    ///
    ///- parameter searchText: Text for search.
    ///- parameter delay: operation delay.
    private func searchAlbums(_ searchText: String, delay: DispatchTime) {
        searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
                DispatchQueue.main.async {
                    self?.showActivity()
                    self?.manager.searchAlbums(searchText) { [weak self] albums, loaded  in
                        self?.albums = albums
                        if loaded {
                            self?.hideActivity()
                        }
                    }
                }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: delay, execute: task)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAlbums(searchText, delay: DispatchTime.now() + 1)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAlbums(searchBar.text ?? "", delay: DispatchTime.now())
    }
}
extension AlbumsViewController: AlbumsDelegate {
    func showError(_ message: String) {
        self.showMessage(message)
    }
}
