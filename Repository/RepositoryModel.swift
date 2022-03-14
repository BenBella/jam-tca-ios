//
//  RepositoryModel.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import Foundation

struct RepositoryModel: Decodable, Equatable {
  enum CodingKeys: String, CodingKey {
    case name, description, language
    case forks = "forksCount"
    case stars = "stargazersCount"
  }

  let name: String
  let description: String?
  let stars: Int
  let forks: Int
  let language: String?
}

extension RepositoryModel: Identifiable {
  var id: String { name }
}
