//
//  PostDetailViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

extension PostDetailViewController {
    final class func create(with viewModel: DefaultPostDetailViewModel) -> PostDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "PostDetailViewController") as! PostDetailViewController
        vc.viewModel = viewModel
        return vc
    }
}

class PostDetailViewController: UIViewController {
    
    static let storybordId = "PostDetailViewController"
    
    private let loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        return viewController
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var commentsLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    private var viewModel: PostDetailViewModel!
    private var postId: Int?
    
    func inject(with viewModel: PostDetailViewModel, postId: Int) {
        self.viewModel = viewModel
        self.postId = postId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptLoadPost()
        observe()
        
        setupTitleLabel()
        setupBodyLabel()
        
        setupContainerView()
    }
    
    private func attemptLoadPost() {
        guard let id = postId else { return }
        viewModel.loadPost(id: id)
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
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let viewModel = appDelegate.appDIContainer.makeCommentsModuleDIContainer().makeCommentsViewModel()
            viewController.inject(viewModel: viewModel, postId: id)
            addChildVC(asChildViewController: viewController, to: containerView)
        }
    }
    
}
