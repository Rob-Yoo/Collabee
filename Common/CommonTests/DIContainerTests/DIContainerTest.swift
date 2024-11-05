//
//  DIContainerTest.swift
//  CommonTests
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import XCTest
@testable import Common

final class DIContainerTest: XCTestCase {

    var sut_shared: TestServiceProtocol?
    var sut_unique: TestServiceProtocol2?
    
    override func setUpWithError() throws {
        print("asdf")
        DIContainer.register(TestServiceProtocol.self) {
            return TestService1()
        }
        
        DIContainer.register(TestServiceProtocol2.self) {
            return TestService2()
        }
        
        sut_shared = DIContainer.resolve(TestServiceProtocol.self, objectScope: .shared)
        sut_unique = DIContainer.resolve(TestServiceProtocol2.self, objectScope: .unique)
    }

    override func tearDownWithError() throws {
        sut_shared = nil
        sut_unique = nil
    }

    func testRegisterAndResolve() {
        print("TETset")
        XCTAssertNotNil(sut_shared)
        XCTAssertEqual(sut_shared?.getData(), "Test Data 1")
    }
    
    func testSingletonBehavior() {
        
        let firstInstance = DIContainer.resolve(TestServiceProtocol.self, objectScope: .shared)
        let secondInstance = DIContainer.resolve(TestServiceProtocol.self, objectScope: .shared)

        XCTAssertTrue(firstInstance === secondInstance)
    }
    
    func testUniqueBehavior() {
        @Injected(objectScope: .unique)
        var otherInstance: TestServiceProtocol2
        
        XCTAssertTrue(sut_unique !== otherInstance)
    }
    
    func testWeakReferenceRemoval() {
        
        var mock: Mock? = Mock(testService: sut_shared)
        
        sut_shared = nil
        XCTAssertNotNil(DIContainer.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이 아니어야 함")

        mock = nil
        XCTAssertNil(DIContainer.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이어야 함")


        let newInstance = DIContainer.resolve(TestServiceProtocol.self, objectScope: .shared)
        XCTAssertNotNil(DIContainer.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이 아니어야 함")
    }

}
