//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import Foundation
class NewsAPI {
  
  private static let API_KEY = "7d74b91d40074539b5fd319102028c9c"
  private static let baseUrl = "https://newsapi.org/v2/"
  private static var page = 1
  static var searchCurrentPage = 1
  
  static func getHeadlines(completion: @escaping (_ result: Any?)->Void) {
    guard let url = URL(string: "\(baseUrl)top-headlines?apiKey=\(API_KEY)&country=us&pageSize=20&page=\(page)") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request, completionHandler:{ data, response, error -> Void in
      do {
        if let data = data {
          do {
            let decodedResponse = try JSONDecoder().decode(Result.self, from: data)
            DispatchQueue.main.async {
              page += 1
              completion(decodedResponse.articles)
            }
          } catch let jsonError as NSError {
            print("JSON decode failed: \(jsonError.localizedDescription)")
          }
          return
        }
      }
    })
    task.resume()
  }

  static func search(query: String, completion: @escaping (_ result: Any?)->Void) {
    guard let url = URL(string: "\(baseUrl)everything?q=\(query)&apiKey=\(API_KEY)&pageSize=20&page=\(searchCurrentPage)") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request, completionHandler:{ data, response, error -> Void in
      do {
        if let data = data {
          do {
            let decodedResponse = try JSONDecoder().decode(Result.self, from: data)
            DispatchQueue.main.async {
              searchCurrentPage += 1
              completion(decodedResponse.articles)
            }
          } catch let jsonError as NSError {
            print("JSON decode failed: \(jsonError.localizedDescription)")
          }
          return
        }
      }
    })
    task.resume()
  }
  
}
