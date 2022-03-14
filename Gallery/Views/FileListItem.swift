//
//  FileListItem.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import SwiftUI

let sizeFormatter: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useMB]
    formatter.isAdaptive = true
    return formatter
}()

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct FileListItem: View {
    let file: DownloadFile
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(file.name)
                Spacer()
                Image(systemName: "chevron.right")
            }
            HStack {
                Image(systemName: "photo")
                Text(sizeFormatter.string(fromByteCount: Int64(file.size)))
                Text(" ")
                Text(dateFormatter.string(from: file.date))
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.bottom, 10)
            .font(.caption)
            .foregroundColor(Color.primary)
        }
    }
}
