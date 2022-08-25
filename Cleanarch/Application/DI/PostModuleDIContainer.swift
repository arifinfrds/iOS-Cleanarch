//
//  PostsSceneDIContainer.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/15/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit

final class PostModuleDIContainer {
    
    struct Dependency {
        let postService: PostService
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Posts
    
    private func makePostsViewController() -> UIViewController {
        let viewController = PostsViewController.create(with: makePostsViewModel())
        return viewController
    }
    
    func makePostsViewModel() -> PostsViewModel {
        let viewModel: PostsViewModel = DefaultPostsViewModel(useCase: makeViewPostsUseCase())
        return viewModel
    }
    
    private func makeViewPostsUseCase() -> ViewPostsUseCase {
        let useCase: ViewPostsUseCase = ViewPostsUseCaseImpl(service: dependency.postService)
        return useCase
    }
    
    // MARK: - PostDetail
    
    private func makePostDetailViewController() -> UIViewController {
        let service: PostService = RemotePostService()
        let useCase: ViewPostUseCase = ViewPostUseCaseImpl(service: service)
        let viewModel = DefaultPostDetailViewModel(useCase: useCase)
        let viewController = PostDetailViewController.create(with: viewModel)
        return viewController
    }
    
    func makePostDetailViewModel() -> PostDetailViewModel {
        let viewModel: PostDetailViewModel = DefaultPostDetailViewModel(useCase: makeViewPostUseCase())
        return viewModel
    }
    
    private func makeViewPostUseCase() -> ViewPostUseCase {
        let useCase: ViewPostUseCase = ViewPostUseCaseImpl(service: dependency.postService)
        return useCase
    }
    
}
