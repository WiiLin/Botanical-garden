//
//  BGApiCenter.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Foundation

class BGApiCenter: BGApiBase {
    static let shared: BGApiCenter = BGApiCenter()
    func getBGBotanicalList(limit: UInt, offset: UInt, completionHandler: @escaping (Result<BotanicalListApi.ResponseType, BGError>) -> Void) {
        let api = BotanicalListApi(scope: "resourceAquire", q: "", limit: limit, offset: offset)
        request(api: api,
                responseType: BotanicalListApi.ResponseType.self,
                completionHandler: completionHandler)
    }
}
