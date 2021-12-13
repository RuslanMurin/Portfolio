//
//  AlbumTableViewCell.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 12.12.2021.
//

import UIKit
/// Song's presentation cell.
class SongTableViewCell: UITableViewCell, InterfaceSetupProtocol {
    static let identifier = "SongCell"

    var song: Song? {
        didSet {
            guard let song = song else { return }
            nameLabel.text = song.trackName
            timeLabel.text = song.trackTimeMillis.toTimeFormat()
        }
    }
/// Shows  current index.
    lazy var indexLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }
/// Shows song's name.
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 2
//        $0.adjustsFontSizeToFitWidth = true
    }
/// Shows song's time.
    private lazy var timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .right
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.contentView.addSubviews(indexLabel, nameLabel, timeLabel)
    }

    func makeConstraints() {
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Insets.space10)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Insets.space5)
            make.leading.equalTo(indexLabel.snp.trailing).inset(-Insets.space5)
            make.height.greaterThanOrEqualTo(40)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(Insets.space10)
            make.centerY.equalToSuperview()
        }
    }
}
