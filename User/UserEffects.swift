//
//  UserEffects.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation
import ComposableArchitecture

func userEffect(decoder: JSONDecoder) -> Effect<UserModel, APIError> {
    guard let url = URL(string: "https://api.github.com/users/benbella") else {
        fatalError("Error on creating url")
    }
    return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { _ in APIError.downloadError }
        .map { data, _ in data }
        .decode(type: UserModel.self, decoder: decoder)
        .mapError { _ in APIError.decodingError }
        .eraseToEffect()
}

func dummyUserEffect(decoder: JSONDecoder) -> Effect<UserModel, APIError> {
    let dummyUser = UserModel(
        name: "Dummy User",
        bio: "This is a dummy user without any real information",
        publicRepos: 100,
        followers: 100)
    return Effect(value: dummyUser)
}
