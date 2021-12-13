//
//  AlbumViewController.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 12.12.2021.
//

import Foundation
import UIKit
/// Controller with information about album.
class AlbumViewController: UIViewController, InterfaceSetupProtocol {

    private let manager = SongsManager()
/// Songs list in album.
    var songs: [Song] = []
/// Activity indicator for loading status.
    private let activityIndicator = UIActivityIndicatorView().then {
        $0.style = Constants.activityStyle
        $0.color = .darkGray
    }
// MARK: - UI elements with album's information.
    private lazy var albumNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
    }
    private lazy var artistLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 2
        $0.textColor = .darkGray
        $0.adjustsFontSizeToFitWidth = true
    }
    private lazy var genreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.adjustsFontSizeToFitWidth = true
    }
    private lazy var objectsLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.adjustsFontSizeToFitWidth = true
    }
    private lazy var releaseLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.adjustsFontSizeToFitWidth = true
    }
    private lazy var songsTableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: Insets.space20, left: 0, bottom: Insets.space20, right: 0)
        $0.delegate = self
        $0.dataSource = self
        $0.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
    }
    private lazy var artworkImageView = UIImageView()

    init(album: Album) {
        super.init(nibName: nil, bundle: nil)
        title = album.collectionName
        showActivity()
        artworkImageView.kf.setImage(with: URL(string: album.artworkUrl100))
        albumNameLabel.text = album.collectionName
        artistLabel.text = album.artistName
        genreLabel.text = album.primaryGenreName
        objectsLabel.text = "Objects: \(album.trackCount)"
        releaseLabel.text = "Release: \(album.releaseDate)"

        manager.getSongs(albumID: album.collectionId) { [weak self] songs, loaded  in
            if loaded {
                self?.songs = songs
                self?.songsTableView.reloadData()
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
    }
    func commonSetup() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubviews(artworkImageView, albumNameLabel, artistLabel, genreLabel, objectsLabel, releaseLabel, songsTableView, artistLabel, activityIndicator)
    }

    func makeConstraints() {
        artworkImageView.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(Insets.space20)
            make.width.height.equalTo(Constants.albumCoverSize)
        }
        albumNameLabel.snp.makeConstraints( { make in
            make.trailing.equalToSuperview().inset(Insets.space20)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(Insets.space10)
            make.top.equalTo(artworkImageView)
        })
        artistLabel.snp.makeConstraints( { make in
            make.trailing.equalToSuperview().inset(Insets.space20)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(Insets.space10)
            make.top.equalTo(albumNameLabel.snp.bottom).offset(Insets.space5)
        })
        releaseLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Insets.space20)
            make.bottom.equalTo(artworkImageView)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(Insets.space10)
        }
        objectsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(releaseLabel.snp.top).inset(-Insets.space3)
            make.trailing.equalToSuperview().inset(Insets.space20)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(Insets.space10)
        }
        genreLabel.snp.makeConstraints { make in
            make.bottom.equalTo(objectsLabel.snp.top).inset(-Insets.space3)
            make.trailing.equalToSuperview().inset(Insets.space20)
            make.leading.equalTo(artworkImageView.snp.trailing).offset(Insets.space10)
            make.top.greaterThanOrEqualTo(artistLabel.snp.bottom).offset(Insets.space10)
        }
        songsTableView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Insets.space20)
            make.top.equalTo(artworkImageView.snp.bottom).offset(Insets.space10)
        }
        activityIndicator.center = view.center
    }
    /// Shows activity indicator.
    private func showActivity() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        songsTableView.isHidden = true
    }
    /// Hides activity indicator.
    private func hideActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        songsTableView.isHidden = false
    }
}
extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier) as? SongTableViewCell {
            cell.indexLabel.text = "\(indexPath.row + 1)"
            cell.song = songs[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
