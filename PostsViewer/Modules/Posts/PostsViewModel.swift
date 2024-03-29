//
//  PostsViewModel.swift
//  PostsViewer
//
//  Created by Bogusław Parol on 22/06/2019.
//  Copyright © 2019 Parbo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol PostsViewModelInput {

    /// call when to load posts without loading view
    var refreshPosts: AnyObserver<Void> { get }

    /// call when viewDidLoad
    var viewDidLoad: AnyObserver<Void> { get }

    /// call on tapping on post
    var selectPost: AnyObserver<Post> { get }

    /// call to show posts filtered for a specific user
    var currentUser: BehaviorRelay<User?> { get }

    /// call to hide modally presented view
    var cancel: AnyObserver<Void> { get }
}

protocol PostsViewModelOutput {

    var loadingViewVisible: Driver<Bool> { get }

    var errorText: Driver<String> { get }

    var hideRefreshIndicator: Driver<Void> { get }

    var posts: Driver<[Post]> { get }

    var selectedPost: Driver<Post> { get }

    var title: Driver<String> { get }

    var addCancelButton: Driver<Void> { get }

    var dismissView: Driver<Void> { get }
}

protocol PostsViewModelType: PostsViewModelInput, PostsViewModelOutput {}

class PostsViewModel: PostsViewModelType {

    // MARK: - Inputs

    var refreshPosts: AnyObserver<Void>

    var viewDidLoad: AnyObserver<Void>

    var selectPost: AnyObserver<Post>

    var currentUser: BehaviorRelay<User?>

    var cancel: AnyObserver<Void>

    // MARK: - Outputs

    var loadingViewVisible: Driver<Bool>

    var errorText: Driver<String>

    var hideRefreshIndicator: Driver<Void>

    var posts: Driver<[Post]>

    var selectedPost: Driver<Post>

    var title: Driver<String>

    var addCancelButton: Driver<Void> = .empty()

    var dismissView: Driver<Void>

    // MARK: -
    private let disposeBag = DisposeBag()
    private let postsProvider: PostsProvider

    init(
        postsProvider: PostsProvider,
        currentUser: BehaviorRelay<User?> = BehaviorRelay<User?>(value: nil),
        withCancelButton: Bool = false) {

        self.postsProvider = postsProvider
        self.currentUser = currentUser

        let _viewDidLoad = PublishSubject<Void>()
        self.viewDidLoad = _viewDidLoad.asObserver()

        let _refreshPosts = PublishSubject<Void>()
        self.refreshPosts = _refreshPosts.asObserver()

        if withCancelButton {
            self.addCancelButton = .just(())
        }

        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.dismissView = _cancel.asObservable()
            .asDriver(onErrorDriveWith: .never())

        self.title = currentUser.asObservable()
            .unwrap()
            .map { "\($0.name)'s Posts"}
            .asDriver(onErrorJustReturn: "")

        let _posts = Observable.merge(
            _viewDidLoad.asObservable(),
            _refreshPosts.asObservable()
        ).flatMap({ _ in
            return postsProvider
                .getPosts(forUserId: currentUser.value?.id)
                .materialize()
        }).share()

        self.errorText = Observable.merge(
            _refreshPosts.map { _ in "" },
            _posts.errors().map { return $0.localizedDescription + "\nPull down to refresh" },
            _posts.elements().map { _ in "" }
        ).asDriver(onErrorDriveWith: .never())

        self.hideRefreshIndicator = Observable.merge(
            _posts.elements().map { _ in () },
            _posts.errors().map { _ in () }
        ).asDriver(onErrorDriveWith: .never())

        self.loadingViewVisible = Observable.merge(
            _viewDidLoad.asObservable().map { _ in true },
            _posts.elements().map { _ in false },
            _posts.errors().map { _ in false }
        ).asDriver(onErrorDriveWith: .never())

        self.posts = Observable.merge(
            _posts.elements(),
            _posts.errors().flatMap { _ -> Observable<[Post]> in .just([]) }
        ).asDriver(onErrorJustReturn: [])

        let _selectPost = PublishSubject<Post>()
        self.selectPost = _selectPost.asObserver()
        self.selectedPost = _selectPost.asDriver(onErrorDriveWith: .never())
    }

    deinit {
        debugPrint("## deinit PostsViewModel")
    }
}
