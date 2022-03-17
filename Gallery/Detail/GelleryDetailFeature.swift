//
//  GelleryDetailFeature.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import ComposableArchitecture

struct GelleryDetailState: Equatable {
    let file: DownloadFile
    var fileData: Data?
    var downloads: [DownloadInfo] = []
}

enum GelleryDetailAction: Equatable {
    case downloadSingle
    case downloadSingleFinished(Result<Data, NSError>)
    case downloadWithUpdates
    case downloadMultipleAction
    case downloadsUpdate([DownloadInfo])
    case closeDetail
    case onAppear
    case onDisappear
}

struct GalleryDetailEnvironment {
    var downloadManager: DownloadManageable
}

let gelleryDetailReducer = Reducer<GelleryDetailState, GelleryDetailAction, SystemEnvironment<GalleryDetailEnvironment>> { state, action, environment in
    struct CancelId: Hashable {}
    
    switch action {
    case .downloadSingle:
        let file = state.file
        return Effect<Any, Never>.catch(receiveOn: environment.mainQueue(), embedIn: GelleryDetailAction.downloadSingleFinished) {
            try await environment.downloadManager.download(file: file)
        }
    case .downloadSingleFinished(let result):
        switch result {
        case .success(let data):
            state.fileData = data
            break
        case .failure:
            break
        }
        return .none
    case .downloadWithUpdates:
        return .none
    case .downloadMultipleAction:
        return .none
    case .downloadsUpdate(let downloads):
        state.downloads = downloads
        return .none
    case .closeDetail:
        return .none
    case .onAppear:
        return environment.downloadManager.downloadsPublisher
        .map(GelleryDetailAction.downloadsUpdate)
        .eraseToEffect()
        .cancellable(id: CancelId())
    case .onDisappear:
        state.fileData = nil
        state.downloads = []
        environment.downloadManager.reset()
        return .cancel(id: CancelId())
    }
}
