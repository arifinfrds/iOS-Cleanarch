//
//  DefaultPostDetailViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation
import CleanarchDomain

enum PostDetailViewModelLoadingType {
    case none
    case fullScreen
}

enum PostDetailViewModelError {
    case none
    case error(String)
}

protocol PostDetailViewModelInput {
    var postId: Observable<Int> { get set }
    func loadPost(id: Int)
}

protocol PostDetailViewModelOutput {
    var post: Observable<Post> { get }
    var error: Observable<PostDetailViewModelError> { get }
    var loadingType: Observable<PostDetailViewModelLoadingType> { get }
}



protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput { }

class DefaultPostDetailViewModel: PostDetailViewModel {
    var postId: Observable<Int> = Observable(0)
    
    var post: Observable<Post> = Observable(Post())
    var error: Observable<PostDetailViewModelError> = Observable(.none)
    var loadingType: Observable<PostDetailViewModelLoadingType> = Observable(.none)
    
    private var showPostUseCase: ViewPostUseCase
    
    init(useCase: ViewPostUseCase) {
        self.showPostUseCase = useCase
    }
    
    func loadPost(id: Int) {
        loadingType.value = .fullScreen
        error.value = .none
        
        showPostUseCase.execute(id: id) { result in
            switch result {
            case .success(let post):
                self.post.value = post
            case .failure(let error):
                self.error.value = .error(error.localizedDescription)
            }
            
            self.loadingType.value = .none
        }
    }
    
}
