//
//  DBService.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 26/09/21.
//

import CouchbaseLiteSwift

class DBService {
    static let shared = DBService()
    
    private let database: Database
    private let databaseName: String = "koombea-db"
    private let idDocument: String = "postsDocument"
    private let tableUserPosts: String = "userPosts"
    private let lastUpdatedKey: String = "lastUpdatedKey"
    
    init() {
        
        if let path = Bundle.main.path(forResource: databaseName, ofType: "cblite2"),
           !Database.exists(withName: databaseName) {
            do {
                try Database.copy(fromPath: path, toDatabase: databaseName, withConfig: nil)
            } catch {
                fatalError("Could not load pre-built database")
            }
        }
        
        do {
            database = try Database(name: databaseName)
        } catch {
            fatalError("Error opening database")
        }
    }
}

extension DBService {
    func add(posts: DataPosts) {
        let mutableDoc = MutableDocument(id: idDocument)
        mutableDoc.removeValue(forKey: tableUserPosts)
        mutableDoc.removeValue(forKey: lastUpdatedKey)
        
        if let postsString = self.jsonToString(json: posts.data) {
            mutableDoc.setString(postsString, forKey: tableUserPosts)
            mutableDoc.setDouble(getToday(), forKey: lastUpdatedKey)
        }
        
        do {
            try database.saveDocument(mutableDoc)
        } catch {
            fatalError("Error saving document")
        }
    }
    
    func get() -> [UserPosts] {
        var userPosts: [UserPosts] = []
        let posts = database.document(withID: idDocument)
        
        if let postsString = posts?.string(forKey: tableUserPosts) {
            userPosts = fromJSON(json: postsString)
        }
        return userPosts
    }
    
    func getLastUpdate() -> Double {
        let lastUpdateTable = database.document(withID: idDocument)
        return lastUpdateTable?.double(forKey: lastUpdatedKey) ?? 0.0
    }
}

// MARK: - Helpers

extension DBService {
    func jsonToString(json: [UserPosts]) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(json)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
            
        } catch let myJSONError {
            print(myJSONError)
            return ""
        }
        
    }
    
    func fromJSON(json: String) -> [UserPosts] {
        var userPosts: [UserPosts] = []
        do {
            let posts = try JSONDecoder().decode([UserPosts].self, from: Data(json.utf8))
            userPosts = posts
            
        } catch let myJSONError {
            print(myJSONError)
            return userPosts
        }
        return userPosts
    }
    
    func getToday() -> Double {
        return Date().timeIntervalSince1970
    }
}
