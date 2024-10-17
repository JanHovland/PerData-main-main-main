//
//  backupCabinToJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 28/11/2021.
//

import SwiftUI

struct backupCabinsToJsonBackupFileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var message : LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var cabins:  [Cabin] = []
    @State private var backupJsonCabin: LocalizedStringKey = "Cabin backup til Json fil"
    
    @State private var isAlertActive = false
    @State private var indicatorShowing = false
    
    let jsonFile = "CabinBackup.json"
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                    Spacer()
                }
                Section(header: Text("Cabin backup to Json"),
                        footer: Text("Backups the cabins to Json")) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text(backupJsonCabin)
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            message = backupCabinsToJsonBackupFile(jsonFile: jsonFile, cabins: cabins)
                            indicatorShowing = false
                            title = "Cabin backup to Json"
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
            .navigationBarTitle(Text(backupJsonCabin), displayMode: .inline)
            .backToCaller("PersonOverView")
            .task { 
                var value: (LocalizedStringKey, [Cabin])
                await value = findCabins()
                if value.0 != "" {
                    message = value.0
                    title = "Error message from the Server"
                    isAlertActive.toggle()
                } else {
                    cabins = value.1
                }
            }
        } // NavigationView
    } // body
    
} // struct

