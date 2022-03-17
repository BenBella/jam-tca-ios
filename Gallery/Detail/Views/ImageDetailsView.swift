//
//  ImageDetailsView.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 17.03.2022.
//

import SwiftUI
import ComposableArchitecture

struct ImageDetailsView: View {
    let store: Store<GelleryDetailState, GelleryDetailAction>
     
    let isDownloading: Bool = false
    let isDownloadActive: Bool = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
        Section(content: {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    if isDownloadActive {
                        ProgressView()
                    }
                    Text("File.name")
                        .font(.title3)
                }
                .padding(.leading, 8)
                Text("From byte count")
                    .font(.body)
                    .foregroundColor(Color.indigo)
                    .padding(.leading, 8)
                if !isDownloading {
                    HStack {
                        Button(action: {
                            //viewStore.send(.closeDetail)
                            viewStore.send(.downloadSingle)
                        }) {
                            Image(systemName: "arrow.down.app")
                            Text("Silver")
                        }
                        .tint(Color.teal)
                        Button(action: {}) {
                            Image(systemName: "arrow.down.app.fill")
                            Text("Gold")
                        }
                        .tint(Color.pink)
                        Button(action: {}) {
                            Image(systemName: "dial.max.fill")
                            Text("Cloud 9")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.purple)
                    }
                    .buttonStyle(.bordered)
                    .font(.subheadline)
                }
            }
    }, header: {
        Label(" Download", systemImage: "arrow.down.app")
            .font(.custom("SerreriaSobria", size: 27))
            .foregroundColor(Color.accentColor)
            .padding(.bottom, 20)
        })
    }
    }
}

