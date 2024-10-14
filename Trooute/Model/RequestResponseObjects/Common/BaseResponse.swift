//
//  BaseResponse.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

protocol BaseResponse {
    associatedtype T
    var success: Bool { get }
    var data: T? { get }
    var message: String { get }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
}
