//
//  PostDetailViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol PostDetailViewModelOutput {
    var post: Observable<Post> { get }
}

class PostDetailViewModel: PostDetailViewModelOutput {
    
    var post: Observable<Post> = Observable(Post())
    var error: Observable<String> = Observable("")
    var loadingType: Observable<PostDetailViewModelLoadingType> = Observable(.none)
    
    enum PostDetailViewModelLoadingType {
        case none
        case fullScreen
    }
    
    private var showPostUseCase: ShowPostUseCase
    
    init(useCase: ShowPostUseCase) {
        self.showPostUseCase = useCase
    }
    
    func loadPost(id: Int) {
        loadingType.value = .fullScreen
        
        showPostUseCase.execute(id: id) { result in
            switch result {
            case .success(let post):
                self.post.value = post
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
            
            self.loadingType.value = .none
        }
    }
    
}
