//
//  GalleryFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import ComposableArchitecture

struct GalleryState: Equatable {
    var status: String = ""
    var files: IdentifiedArrayOf<DownloadFile> = IdentifiedArrayOf(uniqueElements: [])
    var selection: Identified<DownloadFile.ID, GelleryDetailState?>?
}

// Helper Type (keeps GalleryAction: Equatable)
struct TupleResult: Equatable {
    var tuple: (String, [DownloadFile])
    static func == (lhs: TupleResult, rhs: TupleResult) -> Bool {
        lhs.tuple.0 == rhs.tuple.0 && lhs.tuple.1 == rhs.tuple.1
    }
}

enum GalleryAction: Equatable {
    case onAppear
    case onDisappear
    case loadStatus
    case statusLoaded(Result<String, NSError>)
    case loadData
    case dataLoaded(Result<[DownloadFile], NSError>)
    case loadDataConcurrently
    case dataLoadedConcurrently(Result<TupleResult, NSError>)
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
        environment: { env in .live(environment: GalleryDetailEnvironment(downloadManager: env.downloadManager)) }
    )
    .combined(with:
        Reducer<GalleryState, GalleryAction, SystemEnvironment<GalleryEnvironment>> { state, action, environment in
            struct CancelId: Hashable {}
    
            switch action {
            case .onAppear:
                return Effect(value: GalleryAction.loadDataConcurrently)
            case .loadStatus:
                return Effect<Any, Never>.catch(receiveOn: environment.mainQueue(), embedIn: GalleryAction.statusLoaded) {
                    try await environment.downloadManager.status()
                }
            case .statusLoaded(let result):
                switch result {
                case .success(let status):
                    state.status = status
                case .failure:
                    break
                }
                return Effect(value: GalleryAction.loadData)
            case .loadData:
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
            case .loadDataConcurrently:
                return Effect<Any, Never>.catch(receiveOn: environment.mainQueue(), embedIn: GalleryAction.dataLoadedConcurrently) {
                    // Using async let (Swift offers a special syntax that lets you group several asynchronous calls and await them all together.)
                    async let status = try environment.downloadManager.status()
                    async let files = try environment.downloadManager.availableFiles()
                    let result =  try await (status, files)
                    return TupleResult(tuple: result)
                }
            case .dataLoadedConcurrently(let result):
                switch result {
                case .success(let tupleResult):
                    state.status = tupleResult.tuple.0
                    state.files = IdentifiedArrayOf(uniqueElements: tupleResult.tuple.1)
                case .failure:
                    break
                }
                return .none
            case let .setNavigation(selection: .some(id)):
                guard let file = state.files.filter({ $0.id == id }).first else { return .none }
                state.selection = Identified(GelleryDetailState(file: file), id: id)
                return .none
            case .setNavigation(selection: .none):
                state.selection = nil
                return .cancel(id: CancelId())
            case let .galleryDetail(detailAction):
                switch detailAction {
                case .closeDetail:
                    state.selection = nil
                case .onDisappear:
                    environment.downloadManager.reset()
                default:
                    break
                }
                return .none
            case .onDisappear:
                return .none
            }
        }
    )
