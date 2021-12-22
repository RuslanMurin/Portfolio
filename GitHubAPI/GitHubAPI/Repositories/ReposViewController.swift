//
//  ReposViewController.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit
import Bond
import SDWebImage
/// Presents all public repositories(with pagination).
class ReposViewController: UIViewController, InterfaceSetupProtocol {

    let viewModel = ReposViewModel()
/// OAuth access token.
    private let token: String
    private var isLoading = false
/// Loaded repositories.
    private var repositories: Repositories = [] {
        didSet {
        reposCollection.reloadData()
        }
    }
/// CollectionView for repositories.
    private lazy var reposCollection = UICollectionView(frame: .zero,
                                                        collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = Constants.backgroundColor
        $0.delegate = self
        $0.dataSource = self
        $0.register(RepoCollectionViewCell.self, forCellWithReuseIdentifier: RepoCollectionViewCell.identifier)
        $0.contentInset = UIEdgeInsets(top: Insets.space20, left: 0, bottom: Insets.space20, right: 0)
        $0.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.identifier)
    }

    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
        bind()
        view.backgroundColor = Constants.backgroundColor
        viewModel.requestRepos(token: token)
    }

    func commonSetup() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubview(reposCollection)
    }

    func makeConstraints() {
        reposCollection.snp.makeConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Insets.space20)
        }
    }
/// Bind ViewModel's parameters.
    private func bind() {
        viewModel.repositories.bind(to: self) { (strongSelf, repos) in
            strongSelf.repositories = repos
        }
        
        viewModel.error.bind(to: self) { _, error in
            guard error != nil else { return }
            self.showMessage("Loading error.")
        }
    }
}

extension ReposViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repositories.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != repositories.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepoCollectionViewCell.identifier,
                                                                for: indexPath) as? RepoCollectionViewCell else {
                return UICollectionViewCell()
            }
            let repo = repositories[indexPath.row]
            cell.avatarImageView.sd_setImage(with: URL(string: repo.owner.avatarURL))
            cell.ownerLabel.text = repo.owner.login
            cell.nameLabel.text = repo.name
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.identifier,
                                                                for: indexPath) as? IndicatorCell else {
                return UICollectionViewCell()
            }
            cell.inidicator.startAnimating()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let zero = Insets.zero
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? zero) +
                             (flowayout?.sectionInset.left ?? zero) +
                             (flowayout?.sectionInset.right ?? zero)
        let width: CGFloat = indexPath.item == repositories.count
        ? self.view.width - (Insets.space20 * 2)
        : (collectionView.frame.size.width - space) / 3 - Insets.space20
        let height = indexPath.item == repositories.count
        ? 50
        : Constants.cellFontSize * 2 + Insets.space10 * 2 + width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let repo = repositories[indexPath.item]
        let controller = RepoViewController(repo: repo, token: token)
        navigationController?.pushViewController(controller, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == repositories.count - 1 ) {
             viewModel.requestRepos(token: token)
         }
    }
}
