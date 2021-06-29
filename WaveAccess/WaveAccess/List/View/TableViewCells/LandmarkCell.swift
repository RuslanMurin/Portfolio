import UIKit
import SnapKit

class LandmarkCell: UITableViewCell {
    
    var landmark: Landmark?
    
    lazy var nameLabel = UILabel()
    lazy var landmarkImage = UIImageView()
    let favoriteImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(landmarkImage)
        self.accessoryType = .disclosureIndicator
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(landmarkImage.snp.trailing).offset(10)
        }
        
        landmarkImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.width.equalTo(landmarkImage.snp.height)
        }
    }
    
    func showFavoriteStar() {
        
        contentView.addSubview(favoriteImage)
        favoriteImage.image = UIImage(systemName: "star.fill")
        favoriteImage.tintColor = .systemYellow
        
        favoriteImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    func removeStar() {
        self.favoriteImage.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
