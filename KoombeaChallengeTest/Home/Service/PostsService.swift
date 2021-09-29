//
//  PostsService.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import Foundation
import Alamofire

protocol PostServiceProtocol: AnyObject {
    func fetchPosts(completion: @escaping(Result<DataPosts, Error>) -> Void)
}

class PostsService: PostServiceProtocol {
    func fetchPosts(completion: @escaping(Result<DataPosts, Error>) -> Void) {
        let request = AF.request(Constants.postsURL)
        request.responseJSON { response in
            switch response.result {
            
            case .success(_):
                do {
                    let model = try JSONDecoder().decode(DataPosts.self,
                                                         from: response.data!)
                    
                    completion(.success(model))
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
