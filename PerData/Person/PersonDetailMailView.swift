//
//  PersonDetailMailView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct PersonDetailMailView: View {
    var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var isAlertActive = false
    
    enum SheetContent {
        case first
    }
    
    @State private var sheetContent: SheetContent = .first
    @State private var showSheet = false
    
    var body: some View {
        Image("mail")
            .resizable()
            .frame(width: 36, height: 36, alignment: .center)
            .gesture(
                TapGesture()
                    .onEnded({ _ in
                        if person.personEmail.count > 5 {
                            ///  Starter opp PersonSendEmailView()
                            sheetContent = .first
                            showSheet = true
                        } else {
                            message = "Missing personal email" 
                            isAlertActive.toggle()
                        }
                    })
            )
            .alert(Text("Mail"), isPresented: $isAlertActive) {
                Button("OK", action: {})
            } message: {
                Text(message)
            }
            .sheet(isPresented: $showSheet, content: {
                switch sheetContent {
                case .first: PersonSendEmailView(person: person)
                }
            })
    }
}
