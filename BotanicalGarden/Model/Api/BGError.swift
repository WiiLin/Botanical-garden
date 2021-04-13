//
//  BGError.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Foundation
enum BGError: Error {
    case apiResponseError
    case apiResponseSourceError
    case urlCreateError
    case serverErrorParseFailedError
    case custom(String)
    case jsonDecoderDecodeError(Error)
    case serverError(String, Int)
    var description: String {
        switch self {
        case .apiResponseError:
            return "API response error"
        case .apiResponseSourceError:
            return "API response source error"
        case .urlCreateError:
            return "Could not create URL from components"
        case .serverErrorParseFailedError:
            return "Could not parse server error"
        case let .custom(message):
            return message
        case let .serverError(message, _):
            return message
        case let .jsonDecoderDecodeError(error):
            let error = (error as NSError)
            return "\(error.localizedDescription)\n\(error.userInfo)"
        }
    }

    static func serverError(errorObject: [String: Any]) -> BGError {
        if let code = errorObject["code"] as? Int,
            let msg = errorObject["msg"] as? String {
            return .serverError("[\(code)] \(msg)", code)
        }
        return .serverErrorParseFailedError
    }

    static func nsError(error: NSError) -> BGError {
        return .custom(error.localizedDescription)
    }

    var code: Int {
        switch self {
        case let .serverError(_, code):
            return code
        default:
            return 0
        }
    }

    func nsError(code: Int) -> NSError {
        return NSError(domain: "", code: code, userInfo: ["code": "\(code)", "msg": description])
    }
}

extension NSError {
    public var isCancel: Bool {
        if NSURLErrorCancelled == code {
            return true
        } else {
            return false
        }
    }

    public var isInternetError: Bool {
        if NSURLErrorNotConnectedToInternet == code ||
            NSURLErrorTimedOut == code {
            return true
        } else {
            return false
        }
    }
}
