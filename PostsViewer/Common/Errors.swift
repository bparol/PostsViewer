//
//  Errors.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 24/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case loadingResourceFailed(Int)
    case parsingResourceFailed
    case operationFailedPleaseRetry
    case unexpectedResponse

    var errorDescription: String? {
        switch self {
        case .loadingResourceFailed(let code):
            return "Loading data failed with code \(code)!"
        case .parsingResourceFailed:
            return "Parsing data failed!"
        case .operationFailedPleaseRetry:
            return "Operation failed. Please try again."
        case .unexpectedResponse:
            return "Operation failed. Please try again."
        }
    }
}

enum PostDetailsError: Error {
    case receivedInvalidPostDetails
    case userNotFound
}
