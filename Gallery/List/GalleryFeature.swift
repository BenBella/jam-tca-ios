//
//  GalleryFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import ComposableArchitecture

struct GalleryState: Equatable {
    var files: IdentifiedArrayOf<DownloadFile> = IdentifiedArrayOf(uniqueElements: [])
    var selection: Identified<DownloadFile.ID, GelleryDetailState?>?
}

enum GalleryAction: Equatable {
    case onAppear
    case onDisappear
    case dataLoaded(Result<[DownloadFile], NSError>)
    case setNavigation(selection: UUID?)
    case galleryDetail(GelleryDetailAction)
}

struct GalleryEnvironment {
    var downloadManager: DownloadManageable
}

let galleryReducer =
    gelleryDetailReducer
    .optional()
    .pullback(
        state: \Identified.value,
        action: .self,
        environment: { $0 }
    )
    .optional()
    .pullback(
        state: \GalleryState.selection,
        action: /GalleryAction.galleryDetail,
        environment: { _ in .live(environment: GalleryDetailEnvironment()) }
    )
    .combined(with:
        Reducer<GalleryState, GalleryAction, SystemEnvironment<GalleryEnvironment>> { state, action, environment in
            struct CancelId: Hashable {}
    
            switch action {
            case .onAppear:
                return Effect<Any, Never>.catch(receiveOn: environment.mainQueue(), embedIn: GalleryAction.dataLoaded) {
                    try await environment.downloadManager.availableFiles()
                }
            case .dataLoaded(let result):
                switch result {
                case .success(let files):
                    state.files = IdentifiedArrayOf(uniqueElements: files)
                case .failure:
                    break
                }
                return .none
            case let .setNavigation(selection: .some(id)):
                state.selection = Identified(GelleryDetailState(), id: id)
                return .none
            case .setNavigation(selection: .none):
                state.selection = nil
                return .cancel(id: CancelId())
            case let .galleryDetail(detailAction):
                switch detailAction {
                case .closeDetail:
                    state.selection = nil
                }
                return .none
            case .onDisappear:
                return .none
            }
        }
    )
