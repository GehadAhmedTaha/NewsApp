//
//  Article.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import Foundation

struct Result: Codable {
  var articles: [Article]
}

struct Source: Codable {
  var id: String?
  var name: String?
}

struct Article: Codable {
  var source: Source
  var author: String?
  var title: String?
  var description: String?
  var url: String?
  var urlToImage: String?
  var publishedAt: String?
}
