//
//  InterviewDirectoryApp.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import SwiftUI

@main
struct InterviewDirectoryApp: App {
  @StateObject private var controller = CoreDataController()
  
  var body: some Scene {
    WindowGroup {
      InterviewerListView(viewModel: InterviewerListViewModel(moc: controller.container.viewContext))
        .environment(\.managedObjectContext, controller.container.viewContext)
    }
  }
}
