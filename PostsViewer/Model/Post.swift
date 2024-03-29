//
//  Post.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 22/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation

struct Post: Identifiable, Decodable, Equatable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
