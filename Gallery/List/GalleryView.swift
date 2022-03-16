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
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    if viewStore.files.isEmpty {
                        ProgressView().padding()
                    }
                    ForEach(viewStore.files) { file in
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(
                                    state: \.selection?.value,
                                    action: GalleryAction.galleryDetail
                                ),
                                then: GalleryDetailView.init(store:),
                                else: ProgressView.init
                            ),
                            tag: file.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: GalleryAction.setNavigation(selection:)
                            )
                        ) {
                            Text(file.name)
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .onDisappear {
                    viewStore.send(.onDisappear)
                }
                .navigationBarHidden(true)
                //.foregroundColor(Color("magnolia"))
                .background(Color("indigo")
                .edgesIgnoringSafeArea([.top, .leading, .trailing]))
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea([.top, .leading, .trailing])
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
