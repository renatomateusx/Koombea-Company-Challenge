//
//  ControllerViewModel.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit
import Foundation

protocol ViewControllerViewModelDelegate: AnyObject {
    func onSuccessFetchingPost(posts: [UserPosts], lastUpdated: Double)
    func onFailureFetchingPost(error: Error)
}

class ViewControllerViewModel {
    
    // MARK: - Private Properties
    let postService: PostServiceProtocol
    var delegate: ViewControllerViewModelDelegate?
    var isOffLine: Bool = false
    
    // MARK: - Public Properties
    let oneBigImageHeight: CGFloat = 390
    let twoSmallImagesHeight: CGFloat = 191
    let threeImagesHeight: CGFloat = 577
    let fourMoreImagesHeight: CGFloat = 540
    let viewUserDataHeight: CGFloat = 55
    
    // MARK: - Inits
    
    init(with service: PostServiceProtocol) {
        self.postService = service
    }
    
    func fetchPosts() {
        postService.fetchPosts { result in
            switch result {
            
            case .success(let posts):
                DBService.shared.add(posts: posts)
                let posts: [UserPosts] = DBService.shared.get()
                self.isOffLine = false
                self.delegate?.onSuccessFetchingPost(posts: posts,
                                                     lastUpdated: 0)
            case .failure(let error):
                let posts: [UserPosts] = DBService.shared.get()
                if posts.count > 0 {
                    self.isOffLine = true
                    let lastUpdated = DBService.shared.getLastUpdate()
                    self.delegate?.onSuccessFetchingPost(posts: posts,
                                                         lastUpdated: lastUpdated)
                } else {
                    self.delegate?.onFailureFetchingPost(error: error)
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
                height += oneBigImageHeight
            case 2:
                height += twoSmallImagesHeight
            case 3:
                height += threeImagesHeight
            default:
                height += fourMoreImagesHeight
            }
        }
        return height + viewUserDataHeight
    }
}