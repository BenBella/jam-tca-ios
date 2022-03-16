//
//  DownloadsView.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import SwiftUI

struct DownloadsView: View {
    let downloads: [DownloadInfo]
    var body: some View {
        ForEach(downloads) { download in
            VStack(alignment: .leading) {
                Text(download.name).font(.caption)
                ProgressView(value: download.progress)
            }
        }
    }
}
