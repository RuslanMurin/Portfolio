//
//  HistoryViewController.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 13.12.2021.
//

import UIKit
import SnapKit
/// ViewController with search history.
class HistoryViewController: UIViewController, InterfaceSetupProtocol {
/// Requests history list.
    private var requests: [String] = [] {
        didSet {
            print(requests)
            searchHistoryTable.reloadData()
        }
    }
/// Table for present requests history.
    private lazy var searchHistoryTable = UITableView().then {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = UIEdgeInsets(top: Insets.space20, left: 0, bottom: Insets.space20, right: 0)
        $0.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requests = RequestsStorage.requests.reversed()
    }
    func commonSetup() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        view.addSubview(searchHistoryTable)
    }

    func makeConstraints() {
        searchHistoryTable.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier)
                as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.requestLabel.text = requests[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = AlbumsViewController(with: requests[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
