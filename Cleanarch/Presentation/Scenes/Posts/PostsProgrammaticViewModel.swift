//
//  PostsProgrammaticViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/15/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol PostsProgrammaticViewModel: PostsViewModelOutput { }

class DefaultPostsProgrammaticViewModel: PostsProgrammaticViewModel {
    var loadingType: Observable<PostsViewModelLoading> = Observable(.none)
    var items: Observable<[Post]> = Observable([Post]())
    var error: Observable<PostsViewModelError> = Observable(.none)
    var route: Observable<PostsViewModelRoute> = Observable(.initial)

    private var useCase: ShowPostsUseCase?
    
    func loadPosts() {
        loadingType.value = .fullScreen
        
        useCase?.execute(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let posts):
                strongSelf.items.value = posts
            case .failure(let error):
                strongSelf.error.value = .error(error.localizedDescription)
            }
            
            strongSelf.loadingType.value = .none
        })
    }
}
