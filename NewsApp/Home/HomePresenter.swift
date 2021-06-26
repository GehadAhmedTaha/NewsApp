//
//  HomePresenter.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import Foundation
class HomePresenter {
  private var searchResult = [Article]()
  var isSearchModeActive = false
  private var _data = [Article]()
  var data: [Article] {
    get {
      if isSearchModeActive {
        return searchResult
      }
      return _data
    }
    set {
      _data = newValue
    }
  }
  
  init() {
    self.loadData()
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: "SearchStartedNotification"), object: nil, queue: nil) { [self] _ in
      isSearchModeActive = true
    }
    
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: "SearchStoppedNotification"), object: nil, queue: nil) { [self] _ in
      NewsAPI.searchCurrentPage = 1
      isSearchModeActive = false
      NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ReloadDataNotification")))
    }
  }
  
  func loadData() {
    NewsAPI.getHeadlines() { result in
      if let articles = result as? [Article] {
        self._data.append(contentsOf: articles)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ReloadDataNotification")))
      }
    }
  }
  
  func search(for query: String, completion: @escaping (_ result: Any?)->Void) {
    NewsAPI.search(query: query) { result in
      if let searchResult = result as? [Article] {
        self.searchResult = searchResult
        completion(searchResult)
      }
    }
  }
  
  func fetchMoreSearchResult(query: String?) {
    guard let query = query else {return}
    NewsAPI.search(query: query) { result in
      if let searchResult = result as? [Article] {
        self.searchResult.append(contentsOf: searchResult)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ReloadDataNotification")))
      }
    }
  }
}
