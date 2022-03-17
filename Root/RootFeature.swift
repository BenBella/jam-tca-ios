//
//  RootFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import ComposableArchitecture

struct RootState {
    var userState = UserState()
    var repositoryState = RepositoryState()
    var galleryState = GalleryState()
}

enum RootAction {
    case userAction(UserAction)
    case repositoryAction(RepositoryAction)
    case galleryAction(GalleryAction)
}

struct RootEnvironment {}

// swiftlint:disable trailing_closure
let rootReducer = Reducer<RootState, RootAction, SystemEnvironment<RootEnvironment>>.combine(
    userReducer.pullback(
        state: \.userState,
        action: /RootAction.userAction,
        environment: { _ in .live(environment: UserEnvironment(userRequest: userEffect)) }),
    repositoryReducer.pullback(
        state: \.repositoryState,
        action: /RootAction.repositoryAction,
        environment: { _ in .live(environment: RepositoryEnvironment(repositoryRequest: repositoryEffect)) }),
    galleryReducer.pullback(
        state: \.galleryState,
        action: /RootAction.galleryAction,
        environment: { _ in .live(environment: GalleryEnvironment(downloadManager: DownloadManager.shared)) })
)
// swiftlint:enable trailing_closure
