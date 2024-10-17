//
//  HelpToolMain.swift
//  PerData
//
//  Created by Jan Hovland on 02/11/2021.
//

import SwiftUI


/// https://stackoverflow.com/questions/59150320/how-to-bold-text-in-swiftui-textfield


struct zipCodeUpdate: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showMainToolMenu: Bool = false
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive: Bool = false
    @State private var updateZipCode: Bool = false
    @State private var indicatorShowing = false
    
    var body: some View {
        NavigationView {
            Form {
                ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                Section(header: Text("Update ZipCode"),
                        
                        /// Her finnes det et linjeskift \n
                        /// For å få dette med i nb.xloc, trykker du Return der hvor \n ligger i en.xcoc
                        /// \n komme med over, men er vanskelig å se siden det vises som et linjeskift.
                        
                        footer: Text(makeAttributedString(text1: String(localized: "Have uncommented the neccessary function: updateZipCodesFromCSV().\nPress the toggle button for updating..."),
                                                          text2: String(localized: "Press the toggle button for updating..."),
                                                          color1: .red,
                                                          color2: .gray,
                                                          font1: Font.callout.weight(.bold),
                                                          font2: Font.footnote.weight(.regular)))) {
                    HStack {
                        Image(systemName: "signpost.right.fill")
                            .resizable()
                            .frame(width: 29, height: 29)
                            .background(Color.blue)
                            .imageScale(.medium)
                            .cornerRadius(5)
                        Text("ZipCode")
                        
                        Toggle(isOn: $updateZipCode) {}
                        .onTapGesture {
                            updateZipCode.toggle()
                        }
                    }
                    .onTapGesture {
                        Task.init {
                            if updateZipCode {
                                indicatorShowing = true
                                await message = updatePostNummerFromCSV()
                                indicatorShowing = false
                                updateZipCode.toggle()
                                title = "Update ZipCode"
                                isAlertActive.toggle()
                            } else {
                                updateZipCode = false
                                title = "Update ZipCode"
                                message = "You can only Update ZipCode when toggle is on."
                                isAlertActive.toggle()
                            }
                        }
                    }
                    .alert(title, isPresented: $isAlertActive) {
                        Button("OK", action: {})
                    } message: {
                        Text(message)
                    }
                }
            } // VStack
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("ZipCode", displayMode: .inline)
            .backToCaller("PersonOverView")
        } // NavgationView
    } // body
} // struct
