//
//  BGApiPath.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Alamofire
//https://data.taipei/api/v1/dataset/f18de02f-b6c9-47c0-8cda-50efad621c14?scope=resourceAquire&q=&limit=1&offset=0
enum BGApiPath: Equatable {
    case botanicalList
    
    var path: String {
        switch self {
        case .botanicalList:
            return "/api/\(version)/dataset/f18de02f-b6c9-47c0-8cda-50efad621c14"
        }
    }
    
    var version: String {
       return "v1"
    }
}


