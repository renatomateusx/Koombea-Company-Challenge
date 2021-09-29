//
//  Posts.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import Foundation

struct DataPosts: Codable {
    let data: [UserPosts]
}

struct UserPosts: Codable {
    let uid: String
    let name: String
    let email: String
    let profile_pic: String
    let posts: [Post]
}

struct Post: Codable {
    let id: Int
    let date: String
    let pics: [String]
}
