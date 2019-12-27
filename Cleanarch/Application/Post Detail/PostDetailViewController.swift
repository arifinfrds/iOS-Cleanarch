//
//  PostDetailViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    static let storybordId = "PostDetailViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var postId: Int?
    
    private var viewModel: PostDetailViewModel?
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service: PostService = PostServiceImpl()
        let repository: PostRepository = PostRepositoryImpl(postService: service)
        let useCase: ShowPostUseCase = ShowPostUseCaseImpl(postRepository: repository)
        viewModel = PostDetailViewModel(useCase: useCase)
        
        guard let id = postId else { return }
        viewModel?.loadPost(id: id)
        observe()
    }
    
    private func observe() {
        viewModel?.post.observe(on: self, observerBlock: { post in
            self.title = post.title
            self.titleLabel.text = post.title
            self.bodyLabel.text = post.body
        })
        viewModel?.error.observe(on: self, observerBlock: { message in
            self.titleLabel.text = message
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
