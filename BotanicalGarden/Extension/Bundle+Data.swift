//
//  Bundle+Data.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/13.
//

import Foundation

extension Bundle {
    func fileData(resource: String, type: String) -> Data? {
        guard let path = path(forResource: resource, ofType: type) else { return nil }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } catch {
            print(error)
            return nil
        }
    }
}
