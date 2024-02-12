//
//  ResponseError.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

enum ResponseError: Error {
    case network(Error?)
    case decoding
    case noData
    case invalidUrl
    case networkResponse(NetworkResponse)
    case customErr(String?)
    
    var reason: String {
        switch self {
        case .network(let error):
            let msg = "An error occurred while fetching data - \(error?.localizedDescription ?? "")"
            return msg
        case .decoding:
            return "An error occurred while decoding data"
        case .noData:
            return "An error occurred while getting no data"
        case .invalidUrl:
            return "Invalid Request URL"
        case .networkResponse(let response):
            return response.rawValue
        case .customErr(let msg):
            if let msg = msg{
                return msg
            }
            return ""
        }
    }
}
