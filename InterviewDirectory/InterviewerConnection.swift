//
//  InterviewerConnection.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import UIKit
import Foundation
import CoreData
import SwiftUI

class InterviewerConnection {
  
  static func fetchInterviewers(_ moc: NSManagedObjectContext, completion: @escaping (Bool) -> ()) {
    let interviewerURL = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
    
    URLSession.shared.dataTask(with: interviewerURL) { data, response, error in
      if let error = error {
        print("Error getting interviewers: \(error)")
        completion(false)
        return
      }
      if let data = data, let topLevelJson = try? JSONSerialization.jsonObject(with: data) as? [String: [[String: Any]]] {
        let jsonArray = topLevelJson["individuals"] ?? []
        jsonArray.forEach { json in
          let interviewer = Interviewer(context: moc)
          interviewer.id = json[Interviewer.idKey] as? Int16 ?? 0
          interviewer.firstName = json[Interviewer.firstNameKey] as? String ?? ""
          interviewer.lastName = json[Interviewer.lastNameKey] as? String ?? ""
          interviewer.birthdate = json[Interviewer.birthdateKey] as? String ?? ""
          interviewer.profilePicture = json[Interviewer.profilePictureKey] as? String ?? ""
          interviewer.forceSensitive = json[Interviewer.forceSensitiveKey] as? Bool ?? false
          interviewer.affiliation = json[Interviewer.affiliationKey] as? String ?? ""
        }
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        try? moc.save()
        completion(true)
      } else {
        completion(false)
      }
    }.resume()
  }
  
}

//{
//      "id":1,
//      "firstName":"Luke",
//      "lastName":"Skywalker",
//      "birthdate":"1963-05-05",
//      "profilePicture":"https://edge.ldscdn.org/mobile/interview/07.png",
//      "forceSensitive":true,
//      "affiliation":"JEDI"
//    },



extension Interviewer {
  
  static let idKey = "id"
  static let firstNameKey = "firstName"
  static let lastNameKey = "lastName"
  static let birthdateKey = "birthdate"
  static let profilePictureKey = "profilePicture"
  static let forceSensitiveKey = "forceSensitive"
  static let affiliationKey = "affiliation"
  
}
