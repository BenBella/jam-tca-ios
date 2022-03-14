//
//  DownloadInfo.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation

struct DownloadInfo: Identifiable, Equatable {
    let id: UUID
    let name: String
    var progress: Double
}
