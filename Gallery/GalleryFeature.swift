//
//  GalleryFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import ComposableArchitecture

struct GalleryState: Equatable {
    var files: [DownloadFile] = []
}

enum GalleryAction: Equatable {
    case onAppear
    case dataLoaded(Result<[DownloadFile], NSError>)
}

struct GalleryEnvironment {
    var downloadManager: DownloadManager
}

let galleryReducer = Reducer<GalleryState, GalleryAction, SystemEnvironment<GalleryEnvironment>> { state, action, environment in
    switch action {
    case .onAppear:
        return catchEffect(
            scheduler: environment.mainQueue(),
            assignedTo: GalleryAction.dataLoaded) {
                try await environment.downloadManager.availableFiles()
            }         
    case .dataLoaded(let result):
        switch result {
        case .success(let files):
            state.files = files
        case .failure:
            break
        }
        return .none
    }
}
