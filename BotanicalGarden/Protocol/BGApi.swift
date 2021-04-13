//
//  BGApi.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/13.
//

import Alamofire

protocol BGApi {
    associatedtype ResponseType: Decodable
    var request: Encodable? { get }
    var path: String  { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}
