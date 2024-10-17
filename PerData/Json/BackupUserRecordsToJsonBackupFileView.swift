//
//  SwiftJsonUserBackup.swift
//  PerData
//
//  Created by Jan Hovland on 26/11/2021.
//

import SwiftUI

/// Sjekke json: https://jsonformatter.curiousconcept.com/#

struct backupUserRecordsToJsonBackupFileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var message : LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var userRecords:  [UserRecord] = []
    @State private var backupJsonUser: LocalizedStringKey = "User backup til Json fil"
    
    @State private var isAlertActive = false
    @State private var indicatorShowing = false
    
    let jsonFile = "UserRecordBackup.json"
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                    Spacer()
                }
                Section(header: Text("UserRecord backup to Json"),
                        footer: Text("Backups the userRecords to Json")) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text(backupJsonUser)
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            message = backupUserRecordsToJsonBackupFile(jsonFile: jsonFile, userRecords: userRecords)
                            indicatorShowing = false
                            title = "UserRecord backup to Json"
                            isAlertActive.toggle()
                        }
                    }
                }
                .alert(title, isPresented: $isAlertActive) {
                    Button("OK", action: {})
                } message: {
                    Text(message)
                }

            } // Form
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text(backupJsonUser), displayMode: .inline)
            .backToCaller("PersonOverView")
            .task {
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
        } // NavigationView
    } // body
    
} // struct


