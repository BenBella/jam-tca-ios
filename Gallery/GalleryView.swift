//
//  GalleryView.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct GalleryView: View {
    let store: Store<GalleryState, GalleryAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Spacer()
                List {
                  Section(content: {
                      if viewStore.files.isEmpty {
                      ProgressView().padding()
                    }
                      ForEach(viewStore.files) { file in
                      Button(action: {
                        //selected = file
                      }, label: {
                          FileListItem(file: file)
                      })
                    }
                  })
                }
                .padding()
                .onAppear {
                    viewStore.send(.onAppear)
                }
                Spacer()
            }
        }
        .foregroundColor(Color("magnolia"))
        .background(Color("indigo").edgesIgnoringSafeArea([.top, .leading, .trailing]))
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        return GalleryView(
            store: Store(
                initialState: GalleryState(),
                reducer: galleryReducer,
                environment: .dev(environment: GalleryEnvironment(downloadManager: DummyDownloadManager()))
            )
        )
    }
}
