//
//  PostsViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    private let loadingView: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    @IBOutlet var tableView: UITableView!
    let cellId = "PostsCellId"
    
    private(set) var viewModel: PostsViewModel!
    
    final class func create(with viewModel: PostsViewModel) -> PostsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "PostsViewController") as! PostsViewController
        vc.viewModel = viewModel
        return vc
    }
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Injection
        let postService: PostService = PostServiceImpl()
        let postRepository: PostRepository = PostRepositoryImpl(postService: postService)
        let useCase: ShowPostsUseCase = ShowPostsUseCaseImpl(repository: postRepository)
        let viewModel = DefaultPostsViewModel(useCase: useCase)
        self.viewModel = viewModel
        
        viewModel.loadPosts()
        observe()
        
        setupCell()
        setupTableView()
        setupNavBarItem()
    }
    
    private func observe() {
        observeItems()
        observeError()
        observeLoadingType()
        observeRoute()
    }
    
    private func observeItems() {
        viewModel.items.observe(on: self, observerBlock: { posts in
            self.tableView.reloadData()
        })
    }
    
    private func observeError() {
        viewModel.error.observe(on: self) { error in
            switch error {
            case .none: break
            case .error(let message):
                self.showAlertController(withTitle: "Error", message: message, completion: nil)
            }
        }
    }
    
    private func observeLoadingType() {
        viewModel.loadingType.observe(on: self, observerBlock: { loadingType in
            switch loadingType {
            case .fullScreen: self.showLoadingView()
            case .none: self.dismissLoadingView()
            }
        })
    }
    
    private func observeRoute() {
        viewModel.route.observe(on: self, observerBlock: { [weak self] route in
            self?.handle(route)
        })
    }
    
    private func setupNavBarItem() {
        let item = UIBarButtonItem(title: "navigate", style: .plain, target: self, action: #selector(navigate))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func navigate() {
        let viewController = PostsProgrammaticViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func showLoadingView() {
        addChildVC(asChildViewController: loadingViewController, to: view)
    }
    
    private func dismissLoadingView() {
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
        viewController.postId = postId
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
