//
//  Effect+.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import Combine
import ComposableArchitecture

// MARK: Async / Awsait

private func fulfill<Output>(
    _ promise: @escaping ((Result<Output, Never>) -> Void),
    with action: @escaping () async -> Output
) {
    Task { [promise] in
        promise(.success(await action()))
    }
}

private func fulfill<Output>(
    _ promise: @escaping ((Result<Output, NSError>) -> Void),
    with action: @escaping () async throws -> Output
) {
    Task {
        do {
            promise(.success(try await action()))
        } catch {
            promise(.failure(error as NSError))
        }
    }
}

extension Effect where Failure == Never {
    public init(
        receiveOn scheduler: AnySchedulerOf<DispatchQueue>,
        action: @escaping () async -> Output
    ) {
        self = Future<Output, Never> { promise in
            fulfill(promise, with: action)
        }.receive(on: scheduler, options: nil).eraseToEffect()
    }
    
    public static func `catch`<Action, Output>(
        receiveOn scheduler: AnySchedulerOf<DispatchQueue>,
        embedIn someCase: @escaping (Result<Output, NSError>) -> Action,
        action: @escaping () async throws -> Output) -> Effect<Action, Never> {
        Future<Output, NSError> { promise in
            fulfill(promise, with: action)
        }.receive(on: scheduler, options: nil).catchToEffect().map(someCase).eraseToEffect()
    }
}
