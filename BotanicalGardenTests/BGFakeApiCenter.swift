//
//  BGFakeApiCenter.swift
//  BotanicalGardenTests
//
//  Created by Wii Lin on 2021/4/13.
//

@testable import BotanicalGarden
import XCTest

class BGFakeApiCenter: BGRequestProtocol {
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    func getBotanicalList(limit: UInt, offset: UInt, completionHandler: @escaping (Result<BotanicalListApi.ResponseType, BGError>) -> Void) {
        guard let data = Bundle(for: BGFakeApiCenter.self).fileData(resource: "Test", type: "json") else {
            completionHandler(.failure(.urlCreateError))
            return
        }
        do {
            let response = try jsonDecoder.decode(BotanicalListApi.ResponseType.self, from: data)
            completionHandler(.success(response))
        } catch {
            completionHandler(.failure(.jsonDecoderDecodeError(error)))
        }
    }
}
