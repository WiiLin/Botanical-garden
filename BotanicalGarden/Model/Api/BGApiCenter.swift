//
//  BGApiCenter.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Foundation

class BGApiCenter: BGApiBase {
    static let shared: BGApiCenter = BGApiCenter()
    func getBGBotanicalList(limit: Int, offset: Int, completionHandler: @escaping (Result<[BGBotanical], BGError>) -> Void) {
        let api = BotanicalListApi(scope: "resourceAquire", q: "", limit: 1, offset: 1)
        request(api: api,
                responseType: BotanicalListApi.ResponseType.self) { result in
            switch result {
            case let .success(response):
                completionHandler(.success(response.result.results))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
