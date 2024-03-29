//
//  TestDataParser.swift
//  PostsViewerTests
//
//  Created by Bogusław Parol on 24/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation
@testable import PostsViewer

class TestDataParser {

    func loadAndParsePosts() -> [Post]? {
        return loadAndParse(fileName: "Posts")
    }

    func loadAndParseUsers() -> [User]? {
        return loadAndParse(fileName: "Users")
    }

    func loadAndParseComments() -> [Comment]? {
        return loadAndParse(fileName: "Comments")
    }

    private func loadAndParse<T: Decodable>(fileName: String) -> [T]? {
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let items = try? JSONDecoder().decode([T].self, from: data) {
                    return items
                } else {
                    debugPrint("error")
                }
            } catch {
                debugPrint(error)
            }
        }
        return nil
    }
}
