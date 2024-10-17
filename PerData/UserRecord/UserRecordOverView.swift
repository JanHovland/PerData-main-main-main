//
//  UserRecordOverView.swift
//  PerData
//
//  Created by Jan Hovland on 17/11/2021.
//

import SwiftUI
import CloudKit

struct userRecordOverView: View {
    
    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var indicatorShowing = false
    @State private var isAlertActive = false
    
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    
    @State private var indexSetDelete = IndexSet()
    @State private var recordID: CKRecord.ID?
    @State private var userRecords = [UserRecord]()

    var body: some View {
        NavigationView {
            VStack {
                ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                List {
                    ForEach(userRecords) { userRecord in
                        NavigationLink(destination: UserRecordDetailView(userRecord: userRecord)) {
                            showUsers(userRecord: userRecord)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { (indexSet) in
                        indexSetDelete = indexSet
                        recordID = userRecords[indexSet.first!].recordID
                        userRecords.removeAll()
                        Task.init {
                            await message = deleteUserRecord(recordID!)
                            title = "Delete UserRecord"
                            isAlertActive.toggle()
                        }
                    }
                    Spacer()
                }
                
            }
            /// Fjerner ekstra tomt felt med tilhørede linje
            .listStyle(InsetListStyle())
            .listRowSeparator(.hidden)
            .alert(title, isPresented: $isAlertActive) {
                Button("OK", action: {})
            } message: {
                Text(message)
            }
            .navigationBarTitle("User OverView", displayMode: .inline)
            .task {
                if userRecords.count == 0 {
                    indicatorShowing = true
                    await refreshUsers()
                    indicatorShowing = false
                }
            }
            .refreshable {
                await refreshUsers()
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    ControlGroup {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ReturnFromMenuView(text: "PersonOverView")
                        }
                    }
                    .controlGroupStyle(.navigation)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ControlGroup {
                        Button {
                            Task.init {
                                indicatorShowing = true
                                await refreshUsers()
                                indicatorShowing = false
                            }
                        } label: {
                            Text("Refresh")
                        }
                    }
                    .controlGroupStyle(.navigation)
                }
            })
        }
    }
    
    func refreshUsers() async {
        /// Sletter alt tidligere innhold i person
        userRecords.removeAll()
        /// Fetch all persons from CloudKit
        var value: (LocalizedStringKey, [UserRecord], [String])
        await value = findUserRecords()
        if value.0 != "" {
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            userRecords = value.1
        }
    }
    
    struct showUsers: View {
        var userRecord: UserRecord
        
        var body: some View {
            HStack  {
                if userRecord.image != nil {
                    Image(uiImage: userRecord.image!)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .font(.system(size: 16, weight: .ultraLight))
                        .frame(width: 40, height: 40, alignment: .center)
                }
                VStack (alignment: .leading){
                    Text(userRecord.firstName + " " + userRecord.lastName)
                        .font(Font.largeTitle.weight(.ultraLight))
                    Text(userRecord.email)
                        .font(Font.headline.weight(.ultraLight))
                        .padding(.leading, 5)
                }
            }
        }
    }
    
}


