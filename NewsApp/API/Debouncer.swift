//
//  Debouncer.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import Foundation

class Debouncer: NSObject {
  private let delay: TimeInterval
  private var workItem: DispatchWorkItem?
  
  public init(delay: TimeInterval) {
    self.delay = delay
  }
  
  func run(action: @escaping () -> Void) {
    cancel()
    workItem = DispatchWorkItem(block: action)
    if let workItem = workItem {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
  }
  
  func cancel() {
    guard let workItem = workItem else {return}
    workItem.cancel()
  }
}
