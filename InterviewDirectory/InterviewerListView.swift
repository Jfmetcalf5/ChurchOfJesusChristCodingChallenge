//
//  ContentView.swift
//  InterviewDirectory
//
//  Created by Jacob Metcalf on 7/2/22.
//

import SwiftUI
import CoreData

struct InterviewerListView: View {
  
  @Namespace private var interviewerNameSpace
  
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: []) var interviewers: FetchedResults<Interviewer>
  
  @StateObject var viewModel: InterviewerListViewModel
  
  @State var showDetailView = false
  
  @State var selectedInterviewer: Interviewer!
  @State var selectedImage: Image = Global.networkImage
  
  var body: some View {
    if showDetailView {
      self.displayDetailView()
    } else {
      if viewModel.viewState == .loading {
        VStack {
          ProgressView()
          Text("Loading our interviewers")
            .font(Font.system(size: 13).bold())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
          viewModel.fetchInterviewers()
        }
      } else if viewModel.viewState == .error {
        VStack {
          Image(systemName: "close")
            .resizable()
            .foregroundColor(.red)
          Text("Loading our interviewers")
            .font(Font.system(size: 13).bold())
            .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        List(interviewers) { interviewer in
          HStack {
            if viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == interviewer.id })!] != nil {
              viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == interviewer.id })!]!
                .iconStyle
                .matchedGeometryEffect(id: "\(interviewer.id)", in: interviewerNameSpace)
            } else {
              AsyncImage(url: URL(string: (interviewer.profilePicture ?? ""))) { image in
                image
                  .iconStyle
                  .onAppear {
                    viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == interviewer.id })!] = image
                  }
              } placeholder: {
                Global.networkView
              }
            }
            VStack {
              Text("\(interviewer.firstName ?? "") \(interviewer.lastName ?? "")")
                .matchedGeometryEffect(id: Constants.interviewerNameGeometryId(interviewer: interviewer), in: interviewerNameSpace)
                .font(Font.system(size: 22).weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("(\((interviewer.affiliation ?? "").replacingOccurrences(of: "_", with: " ")))")
                .matchedGeometryEffect(id: Constants.interviewerAffiliationGeometryId(interviewer: interviewer), in: interviewerNameSpace)
                .font(Font.system(size: 18).smallCaps().bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
          .contentShape(Rectangle())
          .onTapGesture {
            self.selectedInterviewer = interviewer
            if viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == interviewer.id }) ?? -1] != nil {
              self.selectedImage = viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == interviewer.id })!]!
            } else {
              self.selectedImage = Global.networkImage
            }
            withAnimation {
              self.showDetailView = true
            }
          }
        }
        .listStyle(.plain)
      }
    }
  }
  
  
  func displayDetailView() -> some View {
    VStack {
      HStack {
        Button {
          withAnimation {
            showDetailView = false
          }
        } label: {
          Text("Back")
            .font(Font.system(size: 21))
        }
        .frame(width: 50)
        .padding([.leading, .top])
        .contentShape(Rectangle())
        Spacer()
      }
      
      Spacer()
      
      Text("\(selectedInterviewer.firstName ?? "") \(selectedInterviewer.lastName ?? "")")
        .matchedGeometryEffect(id: Constants.interviewerNameGeometryId(interviewer: selectedInterviewer), in: interviewerNameSpace)
        .font(Font.system(size: 22).weight(.semibold))
      Text("(\((selectedInterviewer.affiliation ?? "").replacingOccurrences(of: "_", with: " ")))")
        .matchedGeometryEffect(id: Constants.interviewerAffiliationGeometryId(interviewer: selectedInterviewer), in: interviewerNameSpace)
        .font(Font.system(size: 18).smallCaps().bold())
      if selectedImage == Global.networkImage {
        AsyncImage(url: URL(string: selectedInterviewer.profilePicture ?? "")) { image in
          image
            .detailStyle(selectedInterviewer, nameSpace: interviewerNameSpace)
            .onAppear {
              viewModel.cachedImages[interviewers.firstIndex(where: { $0.id == selectedInterviewer.id })!] = image
            }
        } placeholder: {
          Global.networkImage
            .detailStyle(selectedInterviewer, nameSpace: interviewerNameSpace)
            .foregroundColor(.gray.opacity(0.3))
        }
      } else {
        selectedImage
          .detailStyle(selectedInterviewer, nameSpace: interviewerNameSpace)
      }
      
      Text("Force Sensitive  \(selectedInterviewer.forceSensitive ? "✅" : "❌")")
        .padding([.bottom, .top], 5)
      Text("🎂 \(DateFormatter.convertBirthdayStringToReadableDate(selectedInterviewer.birthdate ?? "0000-00-00"))")
        .font(Font.system(size: 17, weight: .semibold))
      Spacer()
    }
  }
}

extension Image {
  var iconStyle: some View {
    return self
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 50, height: 50)
  }
  
  func detailStyle(_ interviewer: Interviewer, nameSpace: Namespace.ID) -> some View {
    return self
    .resizable()
    .aspectRatio(contentMode: .fit)
    .matchedGeometryEffect(id: "\(interviewer.id)", in: nameSpace)
    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    InterviewerListView(viewModel: InterviewerListViewModel(moc: NSManagedObjectContext(.mainQueue)))
  }
}
