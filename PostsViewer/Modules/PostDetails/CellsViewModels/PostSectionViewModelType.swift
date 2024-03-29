//
//  PostDetailsCellViewModelType.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 28/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation

enum PostSectionViewModelType {
    case author(PostAuthorViewModel)
    case content(PostContentViewModel)
    case comments(PostCommentsViewModel)
}
