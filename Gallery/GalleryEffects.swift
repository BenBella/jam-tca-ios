//
//  GalleryEffects.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation
import Combine
import ComposableArchitecture

public func catchEffect<Action, Output>(
    scheduler: AnySchedulerOf<DispatchQueue>,
    assignedTo someCase: @escaping (Result<Output, NSError>) -> Action,
    action: @escaping () async throws -> Output) -> Effect<Action, Never> {
    Future<Output, NSError> { promise in
        Task {
            promise(.success(try await action()))
        }
    }.receive(on: scheduler, options: nil).catchToEffect().map(someCase).eraseToEffect()
}
