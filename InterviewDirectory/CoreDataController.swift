//
//  CoreDataController.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
  
  var container = NSPersistentContainer(name: "InterviewDirectory")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading coredata: \(error)")
        return
      }
    }
  }
  
}
