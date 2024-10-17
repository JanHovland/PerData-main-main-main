//
//  BackupPersonsToJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 24/11/2021.
//

import SwiftUI
import CloudKit

struct backupPersonsToJsonBackupFileView: View {
    
    @State private var message : LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var persons = [Person]()
    @State private var backupJson = "Person backup to Json file"
    
    @State private var isAlertActive = false
    @State private var indicatorShowing = false
    
    ///
    /// url finnes i backupPersonsToJsonBackupFile() under :
    /// url = getDocumentsDirectory().appendingPathComponent(jsonFile)
    ///
    /// For å finne filen starter du ** Finder, trykker Shift + Command + G og legger inn url **
    ///
    /// Kopier deretter inn PersonBackup.json inn i Json directory
    ///
    /// Json filen sjekker i https://codebeautify.org/jsonvalidator
    ///
    
    let jsonFile = "PersonBackup.json"
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                    Spacer()
                }
                Section(header: Text("Person backup to Json"),
                        footer: Text("Backups the persons to Json")) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text("Person backup to Json")
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            message = backupPersonsToJsonBackupFile(jsonFile: jsonFile, persons: persons)
                            indicatorShowing = false
                            title = "Person backup to Json"
                            isAlertActive.toggle()
                        }
                    }
                }
                .alert(title, isPresented: $isAlertActive) {
                    Button("OK", action: {})
                } message: {
                    Text(message)
                }
            } //  Form
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("Json backup person", displayMode: .inline)
            .backToCaller("PersonOverView")
        }
        .task {
            var value: (LocalizedStringKey, [Person], [String])
            await value = findPersons()
            if value.0 != "" {
                message = value.0
                title = "Error message from the Server"
                isAlertActive.toggle()
            } else {
                persons = value.1
            }
        }
    }
    
}

