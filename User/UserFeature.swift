//
//  UserFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import ComposableArchitecture

struct UserState: Equatable {
    var user: UserModel?
}

enum UserAction: Equatable {
    case onAppear
    case dataLoaded(Result<UserModel, APIError>)
}

struct UserEnvironment {
    var userRequest: (JSONDecoder) -> Effect<UserModel, APIError>
}

let userReducer = Reducer<UserState, UserAction, SystemEnvironment<UserEnvironment>> { state, action, environment in
    switch action {
    case .onAppear:
        return environment.userRequest(environment.decoder())
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(UserAction.dataLoaded)
    case .dataLoaded(let result):
        switch result {
        case .success(let user):
            state.user = user
        case .failure:
            break
        }
        return .none
    }
}
