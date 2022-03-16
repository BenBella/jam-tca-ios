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

protocol DownloadManageable {
    func status() async throws -> String
    func availableFiles() async throws -> [DownloadFile]
}

class DownloadManager: DownloadManageable {
    
    func status() async throws -> String {
        guard let url = URL(string: "https://jam-rest.herokuapp.com/files/status") else {
            throw "Could not create the URL."
        }
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
        return String(decoding: data, as: UTF8.self)
    }
    
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

class DummyDownloadManager: DownloadManageable {
    
    func status() async throws -> String {
        return "Using 32% of available space, 123 duplicate files."
    }
    
    func availableFiles() async throws -> [DownloadFile] {
        let dummyFiles = [
            DownloadFile(name: "DSC_7470.jpg", size: 2045041, date: Date()),
            DownloadFile(name: "DSC_7482.jpg", size: 1826072, date: Date()),
            DownloadFile(name: "DSC_7493.jpg", size: 2109604, date: Date()),
            DownloadFile(name: "DSC_7511.jpg", size: 1781713, date: Date())
        ]
        return dummyFiles
    }
}
