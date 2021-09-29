//
//  KoombeaChallengeTestTests.swift
//  KoombeaChallengeTestTests
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import XCTest
import Alamofire
@testable import KoombeaChallengeTest

class HomeViewModelTest: XCTestCase {
    
    typealias Completion<T> = ((_ value: T) -> Void)
    var viewModel: HomeViewModel!
    var successCompletion: Completion<Any>!
    var failureCompletion: Completion<Any>!
    lazy var serviceMock: PostServiceMock = PostServiceMock()
    
    override func setUp() {
        viewModel = HomeViewModel(with: serviceMock)
        viewModel?.delegate = self
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testGetPostsIfSuccess() {
        let expectation = XCTestExpectation.init(description: "Users Posts")
        self.successCompletion = { posts in
            XCTAssertNotNil(posts, "No data was downloaded.")
            expectation.fulfill()
        }
        viewModel.fetchPosts()
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testGetPostsIfFailure() {
        let expectation = XCTestExpectation.init(description: "Error")
        serviceMock.isError = true
        self.failureCompletion = { error in
            XCTAssertNotNil(error, "No data was downloaded.")
            expectation.fulfill()
        }
        viewModel.fetchPosts()
        wait(for: [expectation], timeout: 60.0)
    }
}

extension HomeViewModelTest: HomeViewModelDelegate {
    func onSuccessFetchingPost(posts: [UserPosts], lastUpdated: Double) {
        successCompletion(posts)
    }
    
    func onFailureFetchingPost(error: Error) {
        failureCompletion(error)
    }
}
