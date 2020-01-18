//
//  PostsProgrammaticViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/15/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit

class PostsProgrammaticViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    private let cellId = "cellId"
    
    private(set) var viewModel: PostsProgrammaticViewModel!
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCell()
        viewModel = DefaultPostsProgrammaticViewModel()
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: PostsProgrammaticViewModel) {
        viewModel.items.observe(on: self) { [weak self] posts in
            self?.tableView.reloadData()
        }
        viewModel.error.observe(on: self) { [weak self] error in
            switch error {
            case .none: break
            case .error(let message):
                self?.showAlertController(withTitle: "Perhatian", message: message, completion: nil)
            }
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    private func setupCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func showLoadingView() {
        addChildVC(asChildViewController: loadingViewController, to: view)
    }
    
    private func dismissLoadingView() {
        loadingViewController.remove()
    }
}


// MARK: - UITableViewDataSource

extension PostsProgrammaticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let post = viewModel?.items.value[indexPath.row] {
            cell.textLabel?.text = post.title
        }
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension PostsProgrammaticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
