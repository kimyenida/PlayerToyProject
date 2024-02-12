//
//  APIProcess.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation
enum NetworkResponse: String {
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
}

enum NetworkResult<String> {
    case success
    case failure(NetworkResponse)
}
 
typealias RequestErrorHandler = (_ message: String?) -> Void

class APIProcess {
    // 결과 처리 공통 함수
    class func handleResult<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping (Result<T, ResponseError>) -> Void) {
        if let error = error {
            completion(.failure(.network(error)))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.networkResponse(.failed)))
            return
        }
        
        switch handleNetworkResponse(response) {
        case .success:
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(decodedData))
            } catch {
                // 디코딩이 안 되는 경우, EUC-KR로 파싱해서 디코딩 해본다.
                // Dos Korean Encoder
                let dosKoreanEnc = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
                if let responseData = String(data: responseData, encoding: dosKoreanEnc)?.data(using: .utf8) {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decoding))
                    }
                } else {
                    completion(.failure(.decoding))
                }
            }
            
        case .failure(let networkFailureError):
            completion(.failure(.networkResponse(networkFailureError)))
        }
    }
    
    class func handleResult(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping (Result<String, ResponseError>) -> Void) {
        if let error = error {
            completion(.failure(.network(error)))
            return
        }
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.networkResponse(.failed)))
            return
        }
        
        switch handleNetworkResponse(response) {
        case .success:
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            // Dos Korean Encoder
            let dosKoreanEnc = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
            guard let responseData = String(data: data, encoding: dosKoreanEnc)?.data(using: .utf8) else {
                completion(.failure(.decoding))
                return
            }
            
            do {
                let decodedData = try JSONSerialization.jsonObject(with: responseData) as! NSDictionary
                
                let code = decodedData["Code"] as! String
                let msg = decodedData["Message"] as! String
                
                switch code {
                case "S":
                    completion(.success(msg))
                default:
                    completion(.failure(.customErr(msg)))
                }
            } catch {
                completion(.failure(.decoding))
            }
            
        case .failure(let networkFailureError):
            completion(.failure(.networkResponse(networkFailureError)))
        }
    }
    
    class func userhandleResult<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping (Result<T, ResponseError>) -> Void) {
        if let error = error {
            completion(.failure(.network(error)))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.networkResponse(.failed)))
            return
        }
        
        switch handleNetworkResponse(response) {
        case .success:
            guard let responseData = data else {
                completion(.failure(.noData))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String]{
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response.url!, mainDocumentURL: nil)
            }
            let data: NSMutableData = .init()
            data.append(responseData)
            
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data as Data)
                completion(.success(decodedData))
            } catch {
                print(error)
                // 디코딩이 안 되는 경우, EUC-KR로 파싱해서 디코딩 해본다.
                // Dos Korean Encoder
                let dosKoreanEnc = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
                if let responseData = String(data: responseData, encoding: dosKoreanEnc)?.data(using: .utf8) {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decoding))
                    }
                } else {
                    completion(.failure(.decoding))
                }
            }
            
        case .failure(let networkFailureError):
            completion(.failure(.networkResponse(networkFailureError)))
        }
    }
    
    
    class func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<NetworkResponse> {
        switch response.statusCode {
            case 200...299:
                return .success
            case 400:
                return .failure(.badRequest)
            case 401...500:
                return .failure(.authenticationError)
            case 501...599:
                return .failure(.badRequest)
            case 600:
                return .failure(.outdated)
            default:
                return .failure(.failed)
        }
    }
}
