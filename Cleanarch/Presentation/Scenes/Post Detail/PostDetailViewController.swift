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
    var postId: Int?
    
    private var viewModel: DefaultPostDetailViewModel?
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var commentsLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service: PostService = PostServiceImpl()
        let repository: PostRepository = PostRepositoryImpl(postService: service)
        let useCase: ViewPostUseCase = ViewPostUseCaseImpl(postRepository: repository)
        viewModel = DefaultPostDetailViewModel(useCase: useCase)
        
        guard let id = postId else { return }
        viewModel?.loadPost(id: id)
        observe()
        
        setupTitleLabel()
        setupBodyLabel()
        
        setupContainerView()
    }
    
    private func observe() {
        observePost()
        observeError()
        observeLoadingType()
    }
    
    private func observePost() {
        viewModel?.post.observe(on: self, observerBlock: { post in
            self.title = post.title
            self.titleLabel.text = post.title
            self.bodyLabel.text = post.body
        })
    }
    
    private func observeError() {
        viewModel?.error.observe(on: self, observerBlock: { error in
            switch error {
            case .none: break
            case .error(let message):
                self.showAlertController(withTitle: "Error", message: message, completion: nil)
            }
        })
    }
    
    private func observeLoadingType() {
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
    
    private func setupTitleLabel() {
        titleLabel.textColor = .label
    }
    
    private func setupBodyLabel() {
        bodyLabel.textColor = .secondaryLabel
    }
    
    private func setupContainerView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "CommentsViewController") as! CommentsViewController
        guard let id = postId else { return }
        
        let service: CommentService = CommentServiceImpl()
        let repository: CommentRepository = CommentRepositoryImpl(service: service)
        let useCase: ViewCommentsUseCase = ViewCommentsUseCaseImpl(repository: repository)
        let viewModel = CommentsViewModel(useCase: useCase)
        
        viewController.inject(viewModel: viewModel, postId: id)
        
        addChildVC(asChildViewController: viewController, to: containerView)
    }
    
}
