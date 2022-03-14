//
//  AppMain.swift
//  Shared
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct AppMain: App {
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootState(),
          reducer: rootReducer,
          environment: .live(environment: RootEnvironment())))
    }
  }
}
