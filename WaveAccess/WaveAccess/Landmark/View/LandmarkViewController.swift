import UIKit
import SnapKit
import MapKit

class LandmarkViewController: UIViewController {
    
    var landmark: Landmark!
    
    lazy var scrollView = UIScrollView()
    lazy var map = MKMapView()
    lazy var avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    lazy var containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var namelabel = UILabel()
    lazy var starImage = UIImageView()
    lazy var parkLabel = UILabel()
    lazy var stateLabel = UILabel()
    lazy var aboutLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var separatorView = UIView(frame: CGRect(x: 0, y: 300, width: 100, height: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemBackground
        title = landmark.name
        setupUI()
        makeConstraints()
    }
    //MARK:-- Setup UI
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(map)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: landmark.coordinates.latitude, longitude: landmark.coordinates.longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(region, animated: true)
//Подложка для создания тени и скругления одновременно
        scrollView.addSubview(containerView)
        containerView.addSubview(avatar)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 1
        
        avatar.backgroundColor = .systemBackground
        avatar.layer.cornerRadius = view.frame.height * 0.2 * 0.75
        avatar.layer.borderWidth = 5
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        avatar.image = UIImage(named: landmark.imageName)
        
        scrollView.addSubview(namelabel)
        namelabel.text = landmark.name
        namelabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        
        scrollView.addSubview(starImage)
        if landmark.isFavorite{
            starImage.image = UIImage(systemName: "star.fill")
            starImage.tintColor = .systemYellow
        }
        else {
            starImage.image = UIImage(systemName: "star")
            starImage.tintColor = .systemGray
        }
        
        scrollView.addSubview(parkLabel)
        parkLabel.text = landmark.park
        parkLabel.font = UIFont.systemFont(ofSize: 14)
        parkLabel.textColor = .systemGray
        parkLabel.numberOfLines = 0
        
        scrollView.addSubview(stateLabel)
        stateLabel.text = landmark.state
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.textColor = .systemGray
        stateLabel.textAlignment = .right
        
        scrollView.addSubview(separatorView)
        separatorView.layer.borderWidth = 1
        separatorView.layer.borderColor = UIColor.systemGray.cgColor
        separatorView.alpha = 0.2
        
        scrollView.addSubview(aboutLabel)
        aboutLabel.text = "About \(landmark.name)"
        aboutLabel.font = UIFont.systemFont(ofSize: 21)
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.text = landmark.landmarkDescription
        descriptionLabel.numberOfLines = 0
    }
    //MARK:-- Make Constraints(SnapKIT)
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        map.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.4)
        }
        
        avatar.snp.makeConstraints { make in
            make.width.height.equalTo(map.snp.height).multipliedBy(0.75)
            make.height.equalTo(avatar.snp.width)
            make.centerX.equalTo(map)
            make.top.equalTo(map.snp.bottom).inset(view.frame.height * 0.15)
        }
        
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        starImage.snp.makeConstraints { make in
            make.leading.equalTo(namelabel.snp.trailing).offset(10)
            make.centerY.equalTo(namelabel)
        }
        
        parkLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(parkLabel.snp.trailing).offset(5)
        }
        stateLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(parkLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width - 40)
            make.height.equalTo(1)
        }
        
        aboutLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(aboutLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().inset(10)
            make.width.equalTo(view.frame.width - 20)
        }
    }
}

