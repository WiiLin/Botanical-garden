//
//  BGRequestProtocol.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/13.
//

import Foundation

protocol BGRequestProtocol {
    func getBotanicalList(limit: UInt, offset: UInt, completionHandler: @escaping (Result<BotanicalListApi.ResponseType, BGError>) -> Void)
}
