//
//  GlobalHelper.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import SwiftUI

class Global {
  
  static var birthdayFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "yyyy-mm-dd"
    return df
  }
  
  static var readableBirthdayFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "MMM dd yyyy"
    return df
  }
  
  static var networkImage = Image(systemName: "network")
  static var networkView: some View = networkImage.iconStyle.foregroundColor(.gray.opacity(0.3))
  
}


extension DateFormatter {
  static func convertBirthdayStringToReadableDate(_ birthdayString: String) -> String {
    if let date = Global.birthdayFormatter.date(from: birthdayString) {
      let birthdayString = Global.readableBirthdayFormatter.string(from: date)
      if birthdayString.split(separator: " ")[1].first == "0" {
        return birthdayString.replacingOccurrences(of: " 0", with: " ")
      }
      return birthdayString
    }
    return "0000-00-00"
  }
}
