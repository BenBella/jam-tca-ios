//
//  ImagePreview.swift
//  jam-tca (iOS)
//
//  Created by Lukas Andrlik on 15.03.2022.
//

import SwiftUI

struct ImagePreview: View {
    let fileData: Data
    var body: some View {
        Section("Preview") {
            VStack(alignment: .center) {
                if let image = UIImage(data: fileData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                } else {
                    Text("No preview")
                }
            }
        }
    }
}
