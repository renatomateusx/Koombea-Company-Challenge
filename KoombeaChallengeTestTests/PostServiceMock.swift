//
//  PostServiceMock.swift
//  KoombeaChallengeTestTests
//
//  Created by Renato Mateus on 28/09/21.
//

import Foundation
@testable import KoombeaChallengeTest

class PostServiceMock: PostServiceProtocol {
    var isError = false
    func fetchPosts(completion: @escaping (Result<DataPosts, Error>) -> Void) {
        let dataPosts: DataPosts = DataPosts(data: [])
        if isError {
            let error = NSError(domain:"Internet Error",
                              code: 500,
                              userInfo:nil)
            
            completion(.failure(error))
        } else {
            completion(.success(dataPosts))
        }
    }
}
