//
//  AppDIContainer.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 26/02/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

class AppDIContainer {
    
    // MARK: - Network
    lazy var postService: PostService = {
        let service: PostService = PostServiceImpl()
        return service
    }()
    
    lazy var commentService: CommentService = {
        let service: CommentService = CommentServiceImpl()
        return service
    }()
    
    func makePostModuleDIContainer() -> PostModuleDIContainer {
        let dependency = PostModuleDIContainer.Dependency(postService: postService)
        return PostModuleDIContainer(dependency: dependency)
    }
    
    func makeCommentsModuleDIContainer() -> CommentModuleDIContainer {
        let dependency = CommentModuleDIContainer.Dependency(commentService: commentService)
        return CommentModuleDIContainer(dependency: dependency)
    }
}


final class CommentModuleDIContainer {
    struct Dependency {
        let commentService: CommentService
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func makeCommentsViewModel() -> CommentsViewModel {
        let service: CommentService = CommentServiceImpl()
        let repository: CommentRepository = CommentRepositoryImpl(service: service)
        let useCase: ViewCommentsUseCase = ViewCommentsUseCaseImpl(repository: repository)
        let viewModel = CommentsViewModel(useCase: useCase)
        return viewModel
    }
}


