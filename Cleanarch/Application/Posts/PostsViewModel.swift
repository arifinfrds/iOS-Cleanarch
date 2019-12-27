//
//  PostsViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol PostsViewModelOutput {
    var items: Observable<[Post]> { get }
    var error: Observable<String> { get }
}

class PostsViewModel: PostsViewModelOutput {
    
    // MARK: - Outupt
    var items: Observable<[Post]> = Observable([Post]())
    var error: Observable<String> = Observable("")
    var loadingType: Observable<PostsViewModelLoading> = Observable(.none)
    
    private var showPostsUseCase: ShowPostsUseCase
    
    enum PostsViewModelLoading {
        case none
        case fullScreen
    }
    
    init(useCase: ShowPostsUseCase) {
        self.showPostsUseCase = useCase
    }
    
    func loadPosts() {
        loadingType.value = .fullScreen
        
        showPostsUseCase.execute(completion: { result in
            switch result {
            case .success(let posts):
                self.items.value = posts
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
            
            self.loadingType.value = .none
        })
    }
    
}
