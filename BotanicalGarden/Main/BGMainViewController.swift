//
//  BGMainViewController.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import UIKit
import PKHUD

class BGMainViewController: UIViewController, AlertPresentable {

    // MARK: - Properties
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
            tableView.register(UINib(nibName: "\(BGMainCell.self)", bundle: nil), forCellReuseIdentifier: "\(BGMainCell.self)")
        }
    }

    // MARK: - Properties

    private let viewModel: BGMainViewModel = BGMainViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension BGMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.needLoadMore(indexPath: indexPath) {
            viewModel.loadNextPageData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension BGMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataSource.count == 0 {
            self.tableView.setEmptyMessage(title: "No Data", message: "", frame: tableView.bounds)
        } else {
            self.tableView.restore()
        }
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BGMainCell.self)", for: indexPath) as! BGMainCell
        cell.configure(botanical: viewModel.dataSource[indexPath.row])
        return cell
    }
}

// MARK: - TMainViewModelDelegate

extension BGMainViewController: TMainViewModelDelegate {
    func loadNextPageDataCompleted(indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .none)
        tableView.endUpdates()
        HUD.hide()
    }

    func loadDataCompleted() {
        tableView.reloadData()
        HUD.hide()
    }

    func loadDataError(error: BGError) {
        alertError(error: error, action: nil)
        HUD.hide()
    }

    func loadingData() {
        HUD.show(.progress, onView: view)
    }
}
