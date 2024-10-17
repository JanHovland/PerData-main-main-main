//
//  UpdateUserRecordsFromJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 27/11/2021.
//

import SwiftUI
import CloudKit

struct updateUserRecordsFromJsonBackupFileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive: Bool = false
    @State private var indicatorShowing = false
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                    Spacer()
                }
                Section(header: Text("Update from Json"),
                        footer: Text("Update from Json")) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text("UserRecord update Json")
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            await message = UpdateUserRecordsFromJsonBackupFile()
                            indicatorShowing = false
                            title = "UserRecord update Json"
                            isAlertActive.toggle()
                        }
                    }
                    .alert(title, isPresented: $isAlertActive) {
                        Button("OK", action: {})
                    } message: {
                        Text(message)
                    }
                    
                }
                
                
            } // Form
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("UserRecord update Json", displayMode: .inline)
            .backToCaller("PersonOverView")
        } // NavgationView
    } // body
} // struct

