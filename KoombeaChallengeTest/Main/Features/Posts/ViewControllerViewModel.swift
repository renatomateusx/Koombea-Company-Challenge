//
//  ControllerViewModel.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit
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

// MARK: - Helpers
extension ViewControllerViewModel {
    func calculateCell(userPost: UserPosts) -> CGFloat {
        var height: CGFloat = 0
        let posts = userPost.posts
        for post in posts {
            switch post.pics.count {
            case 1:
                height += 393
            case 2:
                height += 191
            case 3:
                height += 577
            default:
                height += 595
            }
        }
        return height + 55
    }
}
