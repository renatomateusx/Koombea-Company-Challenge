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
    typealias Completion<T> = ((_ value: T?) -> Void)
    var viewModel: ViewControllerViewModel?
    var successCompletion: Completion<Any>?
    var failureCompletion: Completion<Any>?
    lazy var serviceMock: PostServiceMock = PostServiceMock()
    override func setUp() {
        viewModel = ViewControllerViewModel(with: serviceMock)
        viewModel?.delegate = self
    }
    
    func testGetPostsIfSuccess() {
        let expectation = XCTestExpectation.init(description: "Users Posts")
        self.successCompletion = { posts in
            XCTAssertNotNil(posts, "No data was downloaded.")
            expectation.fulfill()
        }
        viewModel?.fetchPosts()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetPostsIfFailure() {
        let expectation = XCTestExpectation.init(description: "Error")
        serviceMock.isError = true
        self.failureCompletion = { error in
            XCTAssertNotNil(error, "No data was downloaded.")
            expectation.fulfill()
        }
        viewModel?.fetchPosts()
        wait(for: [expectation], timeout: 10.0)
    }
}

extension KoombeaChallengeTestTests: ViewControllerViewModelDelegate {
    func onSuccessFetchingPost(posts: [UserPosts], lastUpdated: Double) {
        successCompletion?(posts)
    }
    
    func onFailureFetchingPost(error: Error) {
        failureCompletion?(error)
    }

}
