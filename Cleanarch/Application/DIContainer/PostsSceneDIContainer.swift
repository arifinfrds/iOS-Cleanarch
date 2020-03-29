//
//  PostsSceneDIContainer.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/15/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import UIKit

final class PostsSceneDIContainer {
    
    struct Dependencies {
        let postService: PostService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    // MARK: - Posts
    
    func makePostsViewController() -> UIViewController {
        let viewController = PostsViewController.create(with: makePostsViewModel())
        return viewController
    }
    
    private func makePostsViewModel() -> PostsViewModel {
        let viewModel: PostsViewModel = DefaultPostsViewModel(useCase: makeViewPostsUseCase())
        return viewModel
    }
    
    private func makeViewPostsUseCase() -> ViewPostsUseCase {
        let useCase: ViewPostsUseCase = ViewPostsUseCaseImpl(repository: makePostRepository())
        return useCase
    }
    
    private func makePostRepository() -> PostRepository {
        let repository: PostRepository = PostRepositoryImpl(postService: dependencies.postService)
        return repository
    }
    
    
    // MARK: - PostDetail
    
    func makePostDetailViewController() -> UIViewController {
        let service: PostService = PostServiceImpl()
        let repository: PostRepository = PostRepositoryImpl(postService: service)
        let useCase: ViewPostUseCase = ViewPostUseCaseImpl(postRepository: repository)
        let viewModel = DefaultPostDetailViewModel(useCase: useCase)
        let viewController = PostDetailViewController.create(with: viewModel)
        return viewController
    }
    
    private func makePostDetailViewModel() -> PostDetailViewModel {
        let viewModel: PostDetailViewModel = DefaultPostDetailViewModel(useCase: makeViewPostUseCase())
        return viewModel
    }
    
    private func makeViewPostUseCase() -> ViewPostUseCase {
        let useCase: ViewPostUseCase = ViewPostUseCaseImpl(postRepository: makePostRepository())
        return useCase
    }
    
}
