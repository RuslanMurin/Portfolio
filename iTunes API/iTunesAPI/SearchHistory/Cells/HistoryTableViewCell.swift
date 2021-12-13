//
//  HistoryTableViewCell.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 13.12.2021.
//

import UIKit
/// Cell for present request from storage.
class HistoryTableViewCell: UITableViewCell, InterfaceSetupProtocol {
    static let identifier = "HistoryCell"
/// Presents request's text.
    let requestLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.textAlignment = .center
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
        addSubview(requestLabel)
    }

    func makeConstraints() {
        requestLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Insets.space5)
            make.height.equalTo(Insets.space20)
        }
    }

}
