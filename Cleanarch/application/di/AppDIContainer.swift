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
    
    func makePostsSceneDIContainer() -> PostsSceneDIContainer {
        let dependencies = PostsSceneDIContainer.Dependencies(postService: postService)
        return PostsSceneDIContainer(dependencies: dependencies)
        
    }
}
