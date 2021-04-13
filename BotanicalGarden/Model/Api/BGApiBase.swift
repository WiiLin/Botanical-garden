//
//  BGApiBase.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import Alamofire
import Foundation

enum BGApiNotification {
    static let willRequest = NSNotification.Name("willRequest")
    static let didResponse = NSNotification.Name("didResponse")
}

public class BGApiBase: NSObject {
    // MARK: - Properties
    
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    
    private var baseURLComponents: URLComponents = {
        let url = URL(string: "https://data.taipei/")!
        var urlComponents: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        return urlComponents
    }()
    
    private let sessionManager: Session = {
        let session = Session.default
        session.session.configuration.timeoutIntervalForRequest = 60
        return session
    }()
}

// MARK: - Interface

extension BGApiBase {
    func request<ApiRequest: BGApi, ApiResponse: Decodable>(api: ApiRequest,
                                                            responseType: ApiResponse.Type,
                                                            completionHandler: @escaping (Result<ApiResponse, BGError>) -> Void) {
        baseURLComponents.path = api.path
        guard let url = baseURLComponents.url else {
            completionHandler(.failure(.urlCreateError))
            return
        }
        
        let finalParameters: Parameters? = {
            if let requestType = api.request, let parameters = requestType.parameters, !parameters.isEmpty {
                return parameters
            } else {
                return nil
            }
        }()
        let request: DataRequest = sessionManager.request(url,
                                                          method: api.method,
                                                          parameters: finalParameters,
                                                          encoding: api.method == .get ? URLEncoding.default : JSONEncoding.default,
                                                          headers: api.headers,
                                                          interceptor: self)
        NotificationCenter.default.post(name: BGApiNotification.willRequest, object: api)
        self.request(request: request, method: api.method, parameters: finalParameters) { result in
            NotificationCenter.default.post(name: BGApiNotification.didResponse, object: nil)
            switch result {
            case let .success(data):
                if let data = data {
                    do {
                        let response = try self.jsonDecoder.decode(responseType, from: data)
                        completionHandler(.success(response))
                    } catch {
                        print("❌ \(error)")
                        completionHandler(.failure(.jsonDecoderDecodeError(error)))
                    }
                } else if responseType is BGEmpty.Type {
                    completionHandler(.success(BGEmpty() as! ApiResponse))
                } else {
                    completionHandler(.failure(.apiResponseSourceError))
                }
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}

// MARK: - Private Method

private extension BGApiBase {
    func request(request: DataRequest, method: HTTPMethod, parameters: Parameters?, completionHandler: @escaping (Result<Data?, BGError>) -> Void) {
        request
            .validate(statusCode: 200 ..< 400)
            .response { response in
                self.printResponse(response: response, parameters: parameters, method: method)
                switch response.result {
                case let .success(response):
                    completionHandler(.success(response))
                case let .failure(error):
                    if case let  .requestRetryFailed(retryError, _) = error.asAFError, retryError is BGError{
                        completionHandler(.failure(retryError as! BGError))
                    } else {
                        let responseError = error as NSError
                        print("\(responseError.localizedDescription)")
                        if let data = response.data {
                            if let jsonDictionary = data.jsonDataDictionary {
                                completionHandler(.failure(BGError.serverError(errorObject: jsonDictionary)))
                            } else {
                                completionHandler(.failure(BGError.nsError(error: responseError)))
                            }
                        } else {
                            completionHandler(.failure(BGError.nsError(error: responseError)))
                        }
                    }
                    
                }
            }
    }
    
    func printResponse(response: AFDataResponse<Data?>, parameters: Parameters?, method: HTTPMethod) {
        print("🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻")
        print("✈️ \(response.request?.url?.absoluteString ?? "")")
        print("⚙️ \(method.rawValue)")
        let allHTTPHeaderFields = response.request?.allHTTPHeaderFields ?? [:]
        print("📇 \(allHTTPHeaderFields)")
        
        let parameters = parameters ?? [:]
        print("🎒 \(parameters)")
        
        let statusCode = response.response?.statusCode ?? -1
        print("🚥 \(statusCode)")
        
        if let data = response.data {
            print("🎁 \(String(decoding: data, as: UTF8.self))")
        }
        print("🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻")
    }
}

// MARK: - RequestInterceptor

extension BGApiBase: RequestInterceptor {
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetryWithError(error))
    }
}


// MARK: - Alamofire+Custom
private extension Encodable {
    var parameters: Parameters? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? Parameters }
    }
}

// MARK: - Data+Dictionary
private extension Data {
    var jsonDataDictionary: [String: Any]? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? [String: Any] {
                return dictionary
            } else {
                return nil
            }
        } catch {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
}
