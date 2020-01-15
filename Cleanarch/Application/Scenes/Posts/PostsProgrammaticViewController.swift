//
//  PostsProgrammaticViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/15/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit
import CleanarchUIComponents

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
    
    private var viewModel: PostsViewModel?
    
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
        
        // Setup Injection
        let postService: PostService = PostServiceImpl()
        let postRepository: PostRepository = PostRepositoryImpl(postService: postService)
        let useCase: ShowPostsUseCase = ShowPostsUseCaseImpl(repository: postRepository)
        let viewModel = PostsViewModel(useCase: useCase)
        self.viewModel = viewModel
        
        viewModel.loadPosts()
        observe()
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
    
    private func observe() {
        viewModel?.items.observe(on: self, observerBlock: { posts in
            self.tableView.reloadData()
        })
        viewModel?.error.observe(on: self, observerBlock: { message in
            self.showAlertController(withTitle: "Perhatian", message: message, completion: nil)
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
