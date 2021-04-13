//
//  BGFakeApiTest.swift
//  BotanicalGardenTests
//
//  Created by Wii Lin on 2021/4/13.
//

import XCTest
@testable import BotanicalGarden

class BGFakeApiTest: XCTestCase {
    let viewModel: BGMainViewModel = BGMainViewModel(apiCenter: BGFakeApiCenter())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIsFinished() throws {
        let apiExpectation = expectation(description: "apiExpectation")
        viewModel.loadNextPageData { [weak self] success in
            guard let self = self else { return }
            if success {
                XCTAssertTrue(self.viewModel.isFinished)
            } else {
                XCTAssertTrue(false)
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
