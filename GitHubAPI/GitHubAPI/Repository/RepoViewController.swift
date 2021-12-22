//
//  RepoViewController.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 19.12.2021.
//

import UIKit
/// Repository's ViewController.
class RepoViewController: UIViewController, InterfaceSetupProtocol {
/// Owner's avatar.
    private lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
/// Owner's name.
    private lazy var ownerLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .lightGray
    }
/// Repo's name.
    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
/// Last commit message.
    private lazy var commitLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
    }
/// Last commit author.
    private lazy var authorLabel = UILabel().then {
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.systemFont(ofSize: 14)
    }
/// Last commit date.
    private lazy var dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
    }
/// Parents sha.
    private lazy var shaLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .systemGray
        $0.adjustsFontSizeToFitWidth = true
    }
/// Loading indicator.
    private lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.style = Constants.activityStyle
        $0.color = .gray
    }
    private let viewModel: RepoViewModel
/// Repo's last commit.
    private var commit: Commit?

    init(repo: Repository, token: String) {
        self.viewModel = RepoViewModel()
        super.init(nibName: nil, bundle: nil)
        avatarImageView.sd_setImage(with: URL(string: repo.owner.avatarURL))
        nameLabel.text = repo.name
        ownerLabel.text = repo.owner.login
        print(repo.commitsURL)
        bind()
        viewModel.loadLastCommit(commitsUrl: URL(string: repo.commitsURL.replacingOccurrences(of: "{/sha}", with: ""))!,
                                 token: token)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        commonSetup()
    }

    func commonSetup() {
        addSubviews()
        makeConstraints()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    func addSubviews() {
        view.addSubviews(avatarImageView, ownerLabel, nameLabel, commitLabel, authorLabel, dateLabel, shaLabel)
    }

    func makeConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Insets.space20)
            make.width.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(Insets.space10)
        }
        ownerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(Insets.space5)
        }
        commitLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerLabel.snp.bottom).offset(Insets.space20).priority(.high)
            make.leading.trailing.equalToSuperview().inset(Insets.space20)
            make.height.lessThanOrEqualTo(400)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(commitLabel.snp.bottom).offset(Insets.space10)
            make.leading.trailing.equalToSuperview().inset(Insets.space20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(Insets.space3)
            make.leading.trailing.equalToSuperview().inset(Insets.space20)
        }
        shaLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Insets.space3)
            make.leading.trailing.equalToSuperview().inset(Insets.space20)
            make.bottom.equalToSuperview().inset(Insets.space20).priority(.low)
        }
        commitLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        shaLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        view.layoutIfNeeded()
    }
/// Bind ViewModel's parameters.
    func bind() {
        viewModel.lastCommit.bind(to: self) { strongSelf, commit in
            guard let commit = commit else { return }

            self.commitLabel.text = "Last commit message:\n\(commit.message)"
            self.authorLabel.text = "Commit author: \(commit.authorName)"
            self.dateLabel.text = commit.date.convertGithubDate()
            self.shaLabel.text = "Parents sha: \(commit.parentsSha)"
        }

        viewModel.isLoading.bind(to: self) { strongSelf, isLoading in
            if isLoading {
                strongSelf.view.addSubview(strongSelf.activityIndicator)
                strongSelf.activityIndicator.startAnimating()
                strongSelf.activityIndicator.center = strongSelf.view.center
            } else {
                strongSelf.activityIndicator.removeFromSuperview()
            }
        }

        viewModel.error.bind(to: self) { strongSelf, error in
            guard error != nil else { return }
            strongSelf.showMessage("Loading error.")
        }
    }
}
