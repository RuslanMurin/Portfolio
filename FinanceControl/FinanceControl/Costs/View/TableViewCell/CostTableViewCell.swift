import UIKit

class CostTableViewCell: UITableViewCell {

    public var valueLabel = UILabel()
    public var dateLabel = UILabel()
    public var descriptionLabel = UILabel()
    
    public var primaryKey: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for label in [valueLabel, dateLabel, descriptionLabel] {
            contentView.addSubview(label)
            label.textColor = .red
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        descriptionLabel.numberOfLines = 0
        valueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
