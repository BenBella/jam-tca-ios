//
//  RepositoryFeature.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Combine
import ComposableArchitecture

struct RepositoryState: Equatable {
    var repositories: [RepositoryModel] = []
    var favoriteRepositories: [RepositoryModel] = []
}

enum RepositoryAction: Equatable {
    case onAppear
    case dataLoaded(Result<[RepositoryModel], APIError>)
    case favoriteButtonTapped(RepositoryModel)
}

struct RepositoryEnvironment {
    var repositoryRequest: (JSONDecoder) -> Effect<[RepositoryModel], APIError>
}

let repositoryReducer = Reducer<RepositoryState, RepositoryAction, SystemEnvironment<RepositoryEnvironment>>
{ state, action, environment in
    switch action {
    case .onAppear:
        return environment.repositoryRequest(environment.decoder())
            .receive(on: environment.mainQueue())
            .catchToEffect()
            .map(RepositoryAction.dataLoaded)
    case .dataLoaded(let result):
        switch result {
        case .success(let repositories):
            state.repositories = repositories
        case .failure(let error):
            break
        }
        return .none
    case .favoriteButtonTapped(let repository):
        if state.favoriteRepositories.contains(repository) {
            state.favoriteRepositories.removeAll { $0 == repository }
        } else {
            state.favoriteRepositories.append(repository)
        }
        return .none
    }
}


