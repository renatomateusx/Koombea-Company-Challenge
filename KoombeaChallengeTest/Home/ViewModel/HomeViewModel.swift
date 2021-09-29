//
//  ControllerViewModel.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit
import Foundation

protocol HomeViewModelOffLineDelegate: AnyObject {
    func runningOffLine()
}

protocol HomeViewModelDelegate: AnyObject {
    func onSuccessFetchingPost(posts: [UserPosts], lastUpdated: Double)
    func onFailureFetchingPost(error: Error)
}

class HomeViewModel {
    
    // MARK: - Private Properties
    let postService: PostServiceProtocol
    var delegate: HomeViewModelDelegate?
    var offLineDelegate: HomeViewModelOffLineDelegate?
    var isOffLine: Bool = false
    
    // MARK: - Public Properties
    let oneBigImageHeight: CGFloat = 406
    let twoSmallImagesHeight: CGFloat = 222
    let threeImagesHeight: CGFloat = 582
    let fourMoreImagesHeight: CGFloat = 550
    
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
                    self.offLineDelegate?.runningOffLine()
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
