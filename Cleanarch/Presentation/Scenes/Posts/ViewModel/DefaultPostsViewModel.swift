//
//  DefaultPostsViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

enum PostsViewModelLoading {
    case none
    case fullScreen
}

enum PostsViewModelRoute {
    case initial
    case showPostDetail(postId: Int)
}

enum PostsViewModelError {
    case none
    case error(String)
}

protocol PostsViewModelOutput {
    var items: Observable<[Post]> { get }
    var error: Observable<PostsViewModelError> { get }
    var loadingType: Observable<PostsViewModelLoading> { get }
    var route: Observable<PostsViewModelRoute> { get }
}

protocol PostsViewModel: PostsViewModelOutput { }


class DefaultPostsViewModel: PostsViewModel {
    var items: Observable<[Post]> = Observable([Post]())
    var error: Observable<PostsViewModelError> = Observable(.none)
    var loadingType: Observable<PostsViewModelLoading> = Observable(.none)
    var route: Observable<PostsViewModelRoute> = Observable(.initial)
    
    private var useCase: ViewPostsUseCase

    init(useCase: ViewPostsUseCase) {
        self.useCase = useCase
    }
    
    func loadPosts() {
        loadingType.value = .fullScreen
        error.value = .none
        
        useCase.execute(completion: { result in
            switch result {
            case .success(let posts):
                self.items.value = posts
            case .failure(let error):
                self.error.value = .error(error.localizedDescription)
            }
            
            self.loadingType.value = .none
        })
    }
    
}
