//
//  CommentsViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/5/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit
import CleanarchUIComponents

class CommentsViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let cellId = "comment_cell"
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    private var viewModel: CommentsViewModel?
    
    init(viewModel: CommentsViewModel, postId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel?.postId.value = postId
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func inject(viewModel: CommentsViewModel, postId: Int) {
        self.viewModel = viewModel
        self.viewModel?.postId.value = postId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        guard let id = viewModel?.postId.value else { return }
        viewModel?.fetchComments(postId: id)
        
        observe()
    }
    
    private func observe() {
        viewModel?.comments.observe(on: self, observerBlock: { comments in
            print(comments)
            self.tableView.reloadData()
        })
        viewModel?.error.observe(on: self, observerBlock: { errorMessage in
            print(errorMessage)
        })
        viewModel?.loadingType.observe(on: self, observerBlock: { loadingType in
            switch loadingType {
            case .fullScreen: self.showLoadingView()
            case .none: self.dismissLoadingView()
            }
        })
    }
    
    private func showLoadingView() {
        addChildVC(asChildViewController: loadingViewController, to: view)
    }
    
    private func dismissLoadingView() {
        loadingViewController.remove()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    
}


// MARK: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.comments.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let comment = viewModel?.comments.value[indexPath.row]
        
        cell.textLabel?.text = comment?.name
        cell.detailTextLabel?.text = comment?.body
        
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

