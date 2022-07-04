//
//  InterviewerViewModel.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import Foundation
import CoreData
import SwiftUI

class InterviewerListViewModel: ObservableObject {
  
  enum InterviewerViewState {
    case loading, loaded, error
  }
  
  @Published var viewState: InterviewerViewState = .loading
  
  var moc: NSManagedObjectContext
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  
  var cachedImages: [Int: Image] = [:]
  
  func fetchInterviewers() {
    self.viewState = .loading
    InterviewerConnection.fetchInterviewers(moc) { success in
      DispatchQueue.main.async {
        if success {
          self.viewState = .loaded
        } else {
          self.viewState = .error
        }
      }
    }
  }
  
}
