//
//  RootCoordinator.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 22/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation
import RxSwift

class RootCoordinator: BaseCoordinator<Void> {
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let postsCoordinator = PostsCoordinator(navigationController: navigationController)
        return coordinate(to: postsCoordinator)
    }
    
}