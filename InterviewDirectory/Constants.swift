//
//  Constants.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/4/22.
//

import Foundation


class Constants {
  
  static func interviewerNameGeometryId(interviewer: Interviewer) -> String {
    return "\(interviewer.id)-\(interviewer.firstName ?? "")\(interviewer.lastName ?? "")"
  }
  
  static func interviewerAffiliationGeometryId(interviewer: Interviewer) -> String {
    return "\(interviewer.id)-\(interviewer.firstName ?? "")\(interviewer.lastName ?? "")-\(interviewer.affiliation ?? "")"
  }
  
}
