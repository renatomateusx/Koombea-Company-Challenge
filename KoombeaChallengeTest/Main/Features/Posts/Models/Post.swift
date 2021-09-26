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
//
//"uid": "e406bae8-1fd4-4e33-81d3-2fd053a40493",
//      "name": "Charles Riasc",
//      "email": "Delaney.Walsh@gmail.com",
//      "profile_pic": "https://mock.koombea.io/profile/profile9.jpg",
//      "posts": [
//        {
//          "id": 50531,
//          "date": "Tue Mar 08 2022 06:56:06 GMT-0500",
//          "pics": [
//            "https://mock.koombea.io/pics/pics104.jpg"
//          ]
//        },
//        {
//          "id": 5054431,
//          "date": "Tue Mar 08 2022 06:56:06 GMT-0500",
//          "pics": [
//            "https://mock.koombea.io/pics/pics10.jpg",
//            "https://mock.koombea.io/pics/pics11.jpg"
//          ]
//        }
//      ]
