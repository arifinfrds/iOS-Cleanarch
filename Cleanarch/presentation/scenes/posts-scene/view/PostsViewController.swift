//
//  PostsViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit



// MARK: - Dependency Injection Helper

extension PostsViewController {
    
    final class func create(with viewModel: PostsViewModel) -> PostsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "PostsViewController") as! PostsViewController
        vc.viewModel = viewModel
        return vc
    }
    
}

final class PostsViewController: UIViewController {
    
    private let loadingView: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    @IBOutlet var tableView: UITableView!
    let cellId = "PostsCellId"
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    
    private var viewModel: PostsViewModel!
    
    func inject(with viewModel: PostsViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observe()
        
        setupCell()
        setupTableView()
        
        viewModel.viewDidLoad()
    }
    
}


// MARK: - Observing

private extension PostsViewController {
    
    func observe() {
        observeItems()
        observeError()
        observeLoadingType()
        observeRoute()
    }
    
    func observeItems() {
        viewModel.items.observe(on: self, observerBlock: { posts in
            self.tableView.reloadData()
        })
    }
    
    func observeError() {
        viewModel.error.observe(on: self) { error in
            switch error {
            case .none: break
            case .error(let message):
                self.showAlertController(withTitle: "Error", message: message, completion: nil)
            }
        }
    }
    
    func observeLoadingType() {
        viewModel.loadingType.observe(on: self, observerBlock: { loadingType in
            switch loadingType {
            case .fullScreen: self.showLoadingView()
            case .none: self.dismissLoadingView()
            }
        })
    }
    
    func observeRoute() {
        viewModel.route.observe(on: self, observerBlock: { [weak self] route in
            self?.handle(route)
        })
    }
    
}


// MARK: - Views setup

private extension PostsViewController {
    
    
    func setupCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func showLoadingView() {
        addChildVC(asChildViewController: loadingViewController, to: view)
    }
    
    func dismissLoadingView() {
        loadingViewController.remove()
    }
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let post = viewModel.items.value[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = viewModel?.items.value[indexPath.row].id else { return }
        viewModel.route.value = .showPostDetail(postId: id)
    }
    
}


// MARK: - Handle Routing

extension PostsViewController {
    
    private func handle(_ route: PostsViewModelRoute) {
        switch route {
        case .initial: break
        case .showPostDetail(let postId):
            showPostDetail(postId: postId)
        }
    }
    
    private func showPostDetail(postId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: PostDetailViewController.storybordId) as! PostDetailViewController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let viewModel = appDelegate.appDIContainer.makePostModuleDIContainer().makePostDetailViewModel()
            viewController.inject(with: viewModel, postId: postId)
            navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
}
