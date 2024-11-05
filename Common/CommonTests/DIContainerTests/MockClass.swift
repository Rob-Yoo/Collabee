//
//  MockClass.swift
//  CommonTests
//
//  Created by Jinyoung Yoo on 11/5/24.
//

protocol TestServiceProtocol: AnyObject {
    func getData() -> String
}

class TestService1: TestServiceProtocol {
    func getData() -> String {
        return "Test Data 1"
    }
}

protocol TestServiceProtocol2: AnyObject {
    func getData() -> String
}

class TestService2: TestServiceProtocol2 {
    func getData() -> String {
        return "Test Data 2"
    }
}

class Mock {
    var testService: TestServiceProtocol?
    
    init(testService: TestServiceProtocol? = nil) {
        self.testService = testService
    }
}
