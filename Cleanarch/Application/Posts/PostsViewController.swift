//
//  PostsViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let cellId = "PostsCellId"
    
    var viewModel: PostsViewModel?
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        setupTableView()
        
        // Setup Injection
        let postService: PostService = PostServiceImpl()
        let postRepository: PostRepository = PostRepositoryImpl(postService: postService)
        let useCase: ShowPostsUseCase = ShowPostsUseCaseImpl(repository: postRepository)
        let viewModel = PostsViewModel(useCase: useCase)
        self.viewModel = viewModel
        
        viewModel.loadPosts()
        observe()
    }
    
    private func setupCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func observe() {
        viewModel?.items.observe(on: self, observerBlock: { posts in
            self.tableView.reloadData()
        })
        viewModel?.error.observe(on: self, observerBlock: { message in
            self.title = message
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
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let post = viewModel?.items.value[indexPath.row]
        cell.textLabel?.text = post?.title
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
        showPostDetail(postId: id)
    }
    
    private func showPostDetail(postId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: PostDetailViewController.storybordId) as! PostDetailViewController
        viewController.postId = postId
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
