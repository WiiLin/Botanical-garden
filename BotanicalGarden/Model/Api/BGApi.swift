//
//  BGApi.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Alamofire

struct BGEmpty: Codable {}

protocol BGApi {
    associatedtype ResponseType: Decodable
    var request: Encodable? { get }
    var path: String  { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}

struct BotanicalListApi:BGApi, Encodable {
    typealias ResponseType = Response
    struct Response: Decodable {

        struct Result: Decodable {
            let results: [BGBotanical]
        }
        let result: Result
    }
    
    var path: String { return BGApiPath.botanicalList.path }
    var method: HTTPMethod { return .get }
    var headers: HTTPHeaders? { return nil }
    var request: Encodable? { return self }
    
    let scope: String
    let q: String
    let limit: Int
    let offset: Int
    
}


struct BGBotanical: Decodable {
    let name: String
    let location: String
    let feature: String
    let imageUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "F_Name_Ch"
        case location = "F_Location"
        case feature = "F_Feature"
        case imageUrl = "F_Pic01_URL"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        feature = try container.decode(String.self, forKey: .feature)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
}

