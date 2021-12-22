//
//  IndicatorCell.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 20.12.2021.
//

import UIKit
/// Collection view cell for present pagination status.
class IndicatorCell: UICollectionViewCell {
    static let identifier = "IndicatorCell"

    var inidicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        inidicator.style = traitCollection.userInterfaceStyle == .dark ? .white : .gray
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup(){
        contentView.addSubview(inidicator)
        inidicator.center = self.center
        inidicator.startAnimating()
    }
}
