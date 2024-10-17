//
//  UpdatePersonsFromJsonBackupFileView.swift
//  PerData
//
//  Created by Jan Hovland on 08/11/2021.
//

import SwiftUI

struct updatePersonsFromJsonBackupFileView: View {
    
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
                Section(header: Text("Update Persons from a Json"),
                        footer: Text(makeAttributedString(text1: String(localized: "If the person exists, the person will be modified and the original image kept. Please note that if the Person table is empty, the Json backup does not have image information!\nYou can call the update several times."),
                                                          text2: String(localized: "You can call the update several times."),
                                                          color1: .red,
                                                          color2: .gray,
                                                          font1: Font.callout.weight(.bold),
                                                          font2: Font.footnote.weight(.regular)))) {
                    HStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.yellow)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text("Json update person")
                    }
                    .onTapGesture {
                        Task.init {
                            indicatorShowing = true
                            await message = updatePersonsFromJsonBackupFile()
                            indicatorShowing = false
                            title = "Json update person"
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
            .navigationBarTitle("Json update person", displayMode: .inline)
            .backToCaller("PersonOverView")
        } // NavgationView
    } // body
} // struct

