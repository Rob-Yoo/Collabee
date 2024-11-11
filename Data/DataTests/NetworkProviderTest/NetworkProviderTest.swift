//
//  NetworkProviderTest.swift
//  DataTests
//
//  Created by Jinyoung Yoo on 11/11/24.
//

import XCTest
import Combine
@testable import Data

final class NetworkProviderTest: XCTestCase {
    
    var sut: NetworkProvider!
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = DefaultNetworkProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLoginSuccess() throws {
        
        var accessToken: String? = nil
        var refreshToken: String? = nil
        let promise = expectation(description: "로그인 요청에 대한 비동기 작업 테스트")
        
        sut.request(MockAPI.login("jin12243@gmail.com", "Qwer1234!"), LoginResult.self)
            .print("Test Login Success")
            .sink { completion in
                switch completion {
                case .finished:
                    XCTAssertNotNil(accessToken)
                    XCTAssertNotNil(refreshToken)
                case .failure(let error):
                    print(error.errorDescription ?? "")
                }
                promise.fulfill()
            } receiveValue: { loginResult in
                accessToken = loginResult.token.accessToken
                refreshToken = loginResult.token.refreshToken
            }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 10)
    }
    
    func testLoginFail() throws {
        let promise = expectation(description: "로그인 요청에 대한 비동기 작업 테스트")
        
        sut.request(MockAPI.login("asdfjasdf", "zxclvkjasdf"), LoginResult.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.errorDescription)
                    XCTAssertNotNil(error.errorDescription)
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [promise], timeout: 5)
    }
}
