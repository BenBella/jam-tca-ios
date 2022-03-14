//
//  DownloadManager.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

class DownloadManager {
    func availableFiles() async throws -> [DownloadFile] {
        guard let url = URL(string: "https://jam-rest.herokuapp.com/files/list") else {
            throw "Could not create the URL."
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }

        guard let list = try? JSONDecoder()
        .decode([DownloadFile].self, from: data) else {
            throw "The server response was not recognized."
        }
        return list
    }
}
