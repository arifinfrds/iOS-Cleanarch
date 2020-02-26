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
    
    
    // MARK: - Posts List
    func makePostsViewController() -> UIViewController {
        let viewController = PostsViewController.create(with: makePostsViewModel())
        return viewController
    }
    
    func makePostsViewModel() -> PostsViewModel {
        let viewModel: PostsViewModel = DefaultPostsViewModel(useCase: makeViewPostsUseCase())
        return viewModel
    }
    
    func makeViewPostsUseCase() -> ViewPostsUseCase {
        let useCase: ViewPostsUseCase = ViewPostsUseCaseImpl(repository: makePostRepository())
        return useCase
    }
    
    func makePostRepository() -> PostRepository {
        let repository: PostRepository = PostRepositoryImpl(postService: dependencies.postService)
        return repository
    }
    
    
}
