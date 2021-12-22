//
//  RepoCollectionViewCell.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 18.12.2021.
//

import UIKit
import SnapKit

/// Collection view cell for present Repository.
class RepoCollectionViewCell: UICollectionViewCell, InterfaceSetupProtocol {
    static let identifier = "RepoCell"
/// Presents album's artwork
    lazy var avatarImageView = UIImageView()
/// Repository's name.
    lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: Constants.cellFontSize)
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "Album"
        $0.numberOfLines = 2
    }
/// Owner name label.
    lazy var ownerLabel = UILabel().then {
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
        addSubviews(avatarImageView, nameLabel, ownerLabel)
    }

    func makeConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.height.equalTo(self.snp.width)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(Insets.space3)
        }
        ownerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.greaterThanOrEqualToSuperview().priority(.low)
        }
    }
}
