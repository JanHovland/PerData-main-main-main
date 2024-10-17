//
//  UpdateCabinsFromJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 28/11/2021.
//

//
//  UpdateUserRecordsFromJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 27/11/2021.
//

import SwiftUI
import CloudKit

struct updateCabinsFromJsonBackupFileView: View {
    
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
                Section(header: Text("Update Cabin from Json"),
                        footer: Text("Update Cabin from Json")) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text("Cabin update Json")
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            await message = updateCabinsFromJsonBackupFile()
                            indicatorShowing = false
                            title = "Cabin update Json"
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
            .navigationBarTitle("Cabin update Json", displayMode: .inline)
            .backToCaller("PersonOverView")
        } // NavgationView
    } // body
} // struct


