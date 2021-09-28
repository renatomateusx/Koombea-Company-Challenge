//
//  KoombeaChallengeTestTests.swift
//  KoombeaChallengeTestTests
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import XCTest
import Alamofire
@testable import KoombeaChallengeTest

class KoombeaChallengeTestTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetPostsFromAPI() {
        let expectation = XCTestExpectation.init(description: "Users Posts")
        
        PostsService.shared.fetchPosts { result in
            switch result {
            
            case .success(let posts):
                XCTAssertNotNil(posts, "No data was downloaded.")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fail with: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetPostsFromViewModel() {
        let expectation = XCTestExpectation.init(description: "Users Posts")
        let viewModel = ViewControllerViewModel()
        
        viewModel.onSuccessFetchingPost = { (posts, _, _) in
            XCTAssertNotNil(posts, "No data was downloaded.")
            expectation.fulfill()
        }
        
        viewModel.fetchPosts()
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testGetPostsErrorl() {
        let expectation = XCTestExpectation.init(description: "Users Posts Error")
    
        self.fetchPostMockError { result in
            switch result {
            
            case .success(_):
               break
            case .failure(let error):
                XCTAssertNotNil(error, "Error just came up")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 20.0)
    }
    
}

extension KoombeaChallengeTestTests {
    func fetchPostMockError(completion: @escaping(Result<DataPosts, Error>) -> Void) {
        completion(.failure(NSError(domain:"",
                                    code:400,
                                    userInfo:nil)))
    }
}
