//
//  BGApiTest.swift
//  BotanicalGardenTests
//
//  Created by Wii Lin on 2021/4/12.
//

@testable import BotanicalGarden
import XCTest

class BGApiTest: XCTestCase {
    let apiCenter: BGRequestProtocol = BGApiCenter()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiAlive() throws {
        let apiExpectation = expectation(description: "apiExpectation")
        apiCenter.getBotanicalList(limit: 0, offset: 20) { result in
            switch result {
            case .success:
                XCTAssert(true)
            case let .failure(error):
                XCTAssert(false, error.description)
            }
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testApiHasData() throws {
        let apiExpectation = expectation(description: "apiExpectation")
        apiCenter.getBotanicalList(limit: 0, offset: 20) { result in
            switch result {
            case let .success(response):
                XCTAssertFalse(response.result.results.isEmpty, "top data is empty")
            case let .failure(error):
                XCTAssert(false, error.description)
            }
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testApiErrorParse() throws {
        let apiExpectation = expectation(description: "apiExpectation")
        apiCenter.getBotanicalList(limit: 0, offset: 20) { result in
            switch result {
            case .success:
                XCTAssert(true)
            case let .failure(error):
                if case .serverError = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false, error.description)
                }
            }
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
