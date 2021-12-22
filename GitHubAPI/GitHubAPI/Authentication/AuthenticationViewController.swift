//
//  AuthenticationViewController.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit
import AuthenticationServices
import Sugar
import SnapKit
import Bond
import ReactiveKit
/// Authentication ViewController.
class AuthenticationViewController: UIViewController, InterfaceSetupProtocol {

    private let viewModel: AuthenticationViewModel
    private let disposeBag = DisposeBag()
/// Button for start authorization.
    private lazy var loginButton = UIButton().then {
        $0.backgroundColor = .systemPurple
        $0.layer.cornerRadius = Insets.space10
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
/// Logo.
    private lazy var gitHubLogoImageView = UIImageView().then {
        $0.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
        $0.image = UIImage(named: "git")?.withRenderingMode(.alwaysTemplate)
    }
/// Loading indicator.
    private lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.style = Constants.activityStyle
        $0.color = .gray
    }

    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        commonSetup()
        bind()
    }

    func commonSetup() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubviews(loginButton, gitHubLogoImageView)
    }

    func makeConstraints() {
        gitHubLogoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loginButton.snp.makeConstraints  { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gitHubLogoImageView.snp.bottom).offset(Insets.space20)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
/// Bind ViewModel's parameters.
    private func bind() {
        loginButton.reactive.tap.observeNext {
            self.viewModel.startLogin()
        }
        .dispose(in: disposeBag)

        viewModel.token.observeNext { token in
            guard let token = token else { return }
            let vc = createNavController(for: ReposViewController(token: token), title: "Repositories")
            vc.modalPresentationStyle = .overFullScreen
// 0.3 sec delay need for complete default animations.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.present(vc, animated: true)
            }
        }
        .dispose(in: disposeBag)

        viewModel.isLoading.bind(to: self) { strongSelf, isLoading in
            strongSelf.loginButton.isHidden = isLoading
            if isLoading {
                strongSelf.view.addSubview(strongSelf.activityIndicator)
                strongSelf.activityIndicator.startAnimating()
                strongSelf.activityIndicator.center = strongSelf.loginButton.center
            } else {
                strongSelf.activityIndicator.removeFromSuperview()
                strongSelf.activityIndicator.stopAnimating()
            }
        }

        viewModel.error.bind(to: self) { strongSelf, error in
            guard error != nil else { return }
            strongSelf.showMessage("Loading error.")
        }
    }
}
extension AuthenticationViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window!
    }
}
