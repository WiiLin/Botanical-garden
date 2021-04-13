//
//  BGMainModelTest.swift
//  BotanicalGardenTests
//
//  Created by Wii Lin on 2021/4/13.
//

@testable import BotanicalGarden
import XCTest

class BGMainModelTest: XCTestCase {
    let viewModel: BGMainViewModel = BGMainViewModel(apiCenter: BGApiCenter())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNeedLoadMore() throws {
        XCTAssertFalse(viewModel.needLoadMore(indexPath: IndexPath(row: 0, section: 0)))
    }

    func testLoadingFlag() throws {
        viewModel.loadNextPageData { success in }
        XCTAssertTrue(viewModel.isLoading)
    }

    func testLoadNextPageData() throws {
        let offset = viewModel.currentOffset
        let apiExpectation = expectation(description: "apiExpectation")
        viewModel.loadNextPageData { [weak self] success in
            guard let self = self else { return }
            if success {
                XCTAssertTrue(self.viewModel.currentOffset == offset + self.viewModel.page)
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

    func testContentOffset() throws {
        let downRange = viewModel.updateContentOffset(contentOffset: .init(x: 0, y: BGNavigationBar.height / 2.0))
        XCTAssertTrue(downRange == .zero)

        let upRange = viewModel.updateContentOffset(contentOffset: .init(x: 0, y: BGNavigationBar.height))
        XCTAssertTrue(upRange == .init(x: 0, y: BGNavigationBar.height))

        let outOfRange = viewModel.updateContentOffset(contentOffset: .init(x: 0, y: BGNavigationBar.height + 10))
        XCTAssertTrue(outOfRange == nil)
    }

    func testTitleViewTopConstraint() throws {
        let offset = viewModel.updateTitleViewTopConstraint(contentOffset: .init(x: 0, y: 0))
        XCTAssertTrue(offset == BGNavigationBar.height)

        let zeroOffset = viewModel.updateTitleViewTopConstraint(contentOffset: .init(x: 0, y: BGNavigationBar.height))
        XCTAssertTrue(zeroOffset == 0)
    }
}
