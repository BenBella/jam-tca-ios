//
//  GalleryDetailView.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct GalleryDetailView: View {
    let store: Store<GelleryDetailState, GelleryDetailAction>

      var body: some View {
          WithViewStore(self.store) { viewStore in
              List {
                  // Show the details of the selected file and download buttons.
                  ImageDetailsView(store: self.store)
                  if !viewStore.downloads.isEmpty {
                      // Show progress for any ongoing downloads.
                      DownloadsView(downloads: viewStore.downloads)
                  }
                  if let fileData = viewStore.fileData {
                      // Show a preview of the file if it's a valid image.
                      ImagePreview(fileData: fileData)
                  }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}
