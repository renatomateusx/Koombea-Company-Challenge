//
//  ControllerViewModel.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import Foundation

class ViewControllerViewModel {
    
    // MARK: TypeAlias
    
    typealias OnFailureFetchingPost = (() -> Void)
    typealias OnSuccessFetchingPost = (([UserPosts], Bool, Double) -> Void)
    
    // MARK: - Public Properties
    var onFailureFetchingPost: OnFailureFetchingPost?
    var onSuccessFetchingPost: OnSuccessFetchingPost?
    
    func fetchPosts() {
        PostsService.instance.fetchPosts { result in
            switch result {
            
            case .success(let posts):
                DBService.shared.add(posts: posts)
                let posts: [UserPosts] = DBService.shared.get()
                self.onSuccessFetchingPost?(posts, false, 0)
            case .failure(_):
                let posts: [UserPosts] = DBService.shared.get()
                if posts.count > 0 {
                    let lastUpdated = DBService.shared.getLastUpdate()
                    self.onSuccessFetchingPost?(posts, true, lastUpdated)
                } else {
                    self.onFailureFetchingPost?()
                }
            }
        }
    }
}
