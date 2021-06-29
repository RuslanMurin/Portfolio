import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ListViewController: UIViewController {
    
    lazy var headerLabel = UILabel()
    lazy var switcher = UISwitch()
    lazy var isFavoriteLabel = UILabel()
    lazy var mainTableView = UITableView()
    
    private let bag = DisposeBag()
    private let manager = LandmarksManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        makeConstraints()
        bindTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    //MARK:-- Setup UI
    func setupUI() {
        
        view.addSubview(headerLabel)
        headerLabel.text = "Landmarks"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(isFavoriteLabel)
        isFavoriteLabel.text = "Favorites only"
        
        view.addSubview(switcher)
        
        view.addSubview(mainTableView)
        mainTableView.delegate = self
        mainTableView.register(LandmarkCell.self, forCellReuseIdentifier: "LandmarkCell")
        mainTableView.rowHeight = 60
    }
    //MARK:-- Constraints with SnapKIT
    func makeConstraints() {
        
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        isFavoriteLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(switcher).inset(10)
        }
        
        switcher.snp.makeConstraints { make in
            make.centerY.equalTo(isFavoriteLabel)
            make.trailing.equalToSuperview().inset(10)
        }
        
        mainTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.greaterThanOrEqualToSuperview()
            make.top.equalTo(isFavoriteLabel.snp.bottom).offset(5)
        }
    }
    //MARK:-- Tableview bind(Reactive)
    func bindTable() {
        Observable.combineLatest(manager.landmarks, switcher.rx.value)
            .compactMap { $0.1
                ? $0.0.filter { $0.isFavorite }
                : $0.0
            }
            .bind(to: mainTableView.rx.items(cellIdentifier: "LandmarkCell", cellType: LandmarkCell.self)) { row, element, cell in
                cell.landmark = element
                cell.nameLabel.text = element.name
                cell.landmarkImage.image = UIImage(named: element.imageName)
                if element.isFavorite {
                    cell.showFavoriteStar()
                }
                else { cell.removeStar() }
            }
            .disposed(by: bag)
    }
}
//MARK:-- Pushing Landmark's View
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = LandmarkViewController()
        let landmarkCell = tableView.cellForRow(at: indexPath) as! LandmarkCell
        vc.landmark = landmarkCell.landmark
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
