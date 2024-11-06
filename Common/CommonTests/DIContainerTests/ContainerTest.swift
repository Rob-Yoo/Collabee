//
//  ContainerTest.swift
//  CommonTests
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import XCTest
@testable import Common

final class ContainerTest: XCTestCase {

    var sut_container: Container!
    var sut_shared: TestServiceProtocol?
    var sut_unique: TestServiceProtocol2?
    
    override func setUpWithError() throws {
        sut_container = Container()
        sut_container.register(TestServiceProtocol.self) { _ in
            return TestService1()
        }
        
        sut_container.register(TestServiceProtocol2.self) { _ in
            return TestService2()
        }
        
        sut_shared = sut_container.resolve(TestServiceProtocol.self, objectScope: .shared)
        sut_unique = sut_container.resolve(TestServiceProtocol2.self, objectScope: .unique)
    }

    override func tearDownWithError() throws {
        sut_container = nil
        sut_shared = nil
        sut_unique = nil
    }

    func testRegisterAndResolve() {
        print("TETset")
        XCTAssertNotNil(sut_shared)
        XCTAssertEqual(sut_shared?.getData(), "Test Data 1")
    }
    
    func testSingletonBehavior() {
        
        let firstInstance = sut_container.resolve(TestServiceProtocol.self, objectScope: .shared)
        let secondInstance = sut_container.resolve(TestServiceProtocol.self, objectScope: .shared)

        XCTAssertTrue(firstInstance === secondInstance)
    }
    
    func testUniqueBehavior() {
        var otherInstance = sut_container.resolve(TestServiceProtocol2.self, objectScope: .unique)
        
        XCTAssertTrue(sut_unique !== otherInstance)
    }
    
    func testWeakReferenceRemoval() {
        
        var mock: Mock? = Mock(testService: sut_shared)
        
        sut_shared = nil
        XCTAssertNotNil(sut_container.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이 아니어야 함")

        mock = nil
        XCTAssertNil(sut_container.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이어야 함")


        let newInstance = sut_container.resolve(TestServiceProtocol.self, objectScope: .shared)
        XCTAssertNotNil(sut_container.sharedObjectStorage["\(TestServiceProtocol.self)"]?.value, "DIContainer의 단일 인스턴스 스토리지의 value가 nil이 아니어야 함")
    }

}
