//
//  BGMainViewModel.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import UIKit

typealias BGResultHandler = ((Bool) -> Void)?
protocol TMainViewModelDelegate: class {
    func loadDataCompleted()
    func loadNextPageDataCompleted(indexPaths:[IndexPath])
    func loadDataError(error: BGError)
    func loadingData()
}

class BGMainViewModel {
    // MARK: - init
    init(apiCenter: BGRequestProtocol) {
        self.apiCenter = apiCenter
    }

    // MARK: - Properties
    let page: UInt = 20
    private(set) var currentOffset: UInt = 0
    private(set) var isFinished: Bool = false
    private(set) var isLoading: Bool = false
    private let apiCenter: BGRequestProtocol
    var dataSource: [BGBotanical] = []
    
    
    weak var delegate: TMainViewModelDelegate? {
        didSet {
            loadData(offset: 0)
        }
    }

    // MARK: - Interface

    func needLoadMore(indexPath: IndexPath) -> Bool {
        if indexPath.row == dataSource.count - 1 {
            return true
        } else {
            return false
        }
    }

    func loadNextPageData(resultHandler: BGResultHandler = nil) {
        loadData(offset: currentOffset + page, resultHandler: resultHandler)
    }
    
    func updateContentOffset(contentOffset: CGPoint) -> CGPoint? {
        let downRange = 0.0...BGNavigationBar.height / 2.0
        let upRange = ((BGNavigationBar.height / 2.0) + 1.0)...BGNavigationBar.height
        if downRange.contains(contentOffset.y) {
            return .zero
        } else if upRange.contains(contentOffset.y) {
            return .init(x: 0, y: BGNavigationBar.height)
        } else {
            return nil
        }
    }
    
    func updateTitleViewTopConstraint(contentOffset: CGPoint) -> CGFloat {
        let offset = BGNavigationBar.height - contentOffset.y
        if offset <= 0 {
            return 0
        } else if offset >= BGNavigationBar.height {
            return BGNavigationBar.height
        }
        return offset
    }

   
}

// MARK: - Private
private extension BGMainViewModel {
    func loadData(offset: UInt, resultHandler: BGResultHandler = nil) {
        guard isFinished == false else { return }
        guard isLoading == false else { return }
        delegate?.loadingData()
        isLoading = true
        apiCenter.getBotanicalList(limit: page, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case let .success(response):
                if offset == 0 {
                    self.dataSource.removeAll()
                    self.dataSource = response.result.results
                    self.delegate?.loadDataCompleted()
                } else {
                    let count = self.dataSource.count
                    var indexPath: [IndexPath] = []
                    self.dataSource += response.result.results
                    for index in count..<self.dataSource.count {
                        indexPath.append(IndexPath(row: index, section: 0))
                    }
                    self.delegate?.loadNextPageDataCompleted(indexPaths: indexPath)
                }
                self.currentOffset = offset
                self.isFinished = self.dataSource.count == response.result.count
                resultHandler?(true)
            case let .failure(error):
                self.delegate?.loadDataError(error: error)
                resultHandler?(false)
            }
        }
    }
}
