//
//  PostDetailsCommentsViewModel.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 28/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import UIKit

class PostCommentsViewModel {

    let comments: [Comment]

    init(comments: [Comment]) {
        self.comments = comments
    }
}
