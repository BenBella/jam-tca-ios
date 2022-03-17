//
//  DownloadManager.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation
import Combine

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

protocol DownloadManageable {
    func status() async throws -> String
    func availableFiles() async throws -> [DownloadFile]
    func download(file: DownloadFile) async throws -> Data
    func reset()
    var downloadsPublisher: Published<[DownloadInfo]>.Publisher { get }
}

class DownloadManager: DownloadManageable {
    
    static let shared = DownloadManager()
    private init(){}
    
    /// The list of currently running downloads.
    @Published var downloads: [DownloadInfo] = []
    var downloadsPublisher: Published<[DownloadInfo]>.Publisher { $downloads }
    
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
    
    /// Downloads a file and returns its content.
    func download(file: DownloadFile) async throws -> Data {
        guard let url = URL(string: "https://jam-rest.herokuapp.com/files/download?\(file.name)") else {
            throw "Could not create the URL."
        }

        await addDownload(name: file.name)
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        await updateDownload(name: file.name, progress: 1.0)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
        return data
    }
    
    func reset() {
      downloads.removeAll()
    }
}

class DummyDownloadManager: DownloadManageable {
    
    @Published var downloads: [DownloadInfo] = []
    var downloadsPublisher: Published<[DownloadInfo]>.Publisher { $downloads }
    
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
    
    func download(file: DownloadFile) async throws -> Data {
        Data()
    }
    
    func reset() {
        downloads.removeAll()
    }
}

extension DownloadManager {
    /// Adds a new download.
    @MainActor func addDownload(name: String) {
        let downloadInfo = DownloadInfo(id: UUID(), name: name, progress: 0.0)
        downloads.append(downloadInfo)
    }
  
    /// Updates a the progress of a given download.
    @MainActor func updateDownload(name: String, progress: Double) {
        if let index = downloads.firstIndex(where: { $0.name == name }) {
            var info = downloads[index]
            info.progress = progress
            downloads[index] = info
        }
    }
}
