//
//  GelleryDetailFeature.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import ComposableArchitecture

struct GelleryDetailState: Equatable {
}

enum GelleryDetailAction: Equatable {
    case closeDetail
}

struct GalleryDetailEnvironment {
}

let gelleryDetailReducer = Reducer<GelleryDetailState, GelleryDetailAction, SystemEnvironment<GalleryDetailEnvironment>> { state, action, _ in
    return .none
}
