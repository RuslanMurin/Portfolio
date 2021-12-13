//
//  AlbumCollectionViewCell.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 09.12.2021.
//

import UIKit
import SnapKit
import Kingfisher
import Accelerate
/// Collection view cell for album.
class AlbumCollectionViewCell: UICollectionViewCell, InterfaceSetupProtocol {
    static let identifier = "AlbumCell"
/// Cell's album.
    var album: Album? {
        didSet {
            guard let album = album else { return }
            coverImageView.kf.setImage(with: URL(string: album.artworkUrl100))
            coverImageView.kf.indicatorType = .activity
            nameLabel.text = album.collectionName
            artistLabel.text = album.artistName
        }
    }
/// Presents album's artwork
    private lazy var coverImageView = UIImageView()
/// Album's name.
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: Constants.cellFontSize)
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "Album"
        $0.numberOfLines = 2
    }
/// Artist name label.
    private lazy var artistLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: Constants.cellFontSize)
        $0.textColor = .darkGray
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "Artist"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonSetup() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        addSubviews(coverImageView, nameLabel, artistLabel)
    }

    func makeConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.height.equalTo(self.snp.width)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(coverImageView.snp.bottom).offset(Insets.space3)
        }
        artistLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.greaterThanOrEqualToSuperview()
        }
    }
}
