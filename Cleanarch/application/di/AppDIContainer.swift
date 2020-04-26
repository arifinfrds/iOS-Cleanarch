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

