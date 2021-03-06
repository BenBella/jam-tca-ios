//
//  DownloadFile.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation

struct DownloadFile: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    let name: String
    let size: Int
    let date: Date
    
    enum CodingKeys: String, CodingKey {
         case name
         case size
         case date
    }
    
    static let empty = DownloadFile(name: "", size: 0, date: Date())
}
