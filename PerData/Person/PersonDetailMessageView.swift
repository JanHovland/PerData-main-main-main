//
//  PersonDetailMessageView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct PersonDetailMessageView: View {
    var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var isAlertActive = false
    
    var body: some View {
        Image("message")
        /// Formatet er : tel:<phone><&body>
            .resizable()
            .frame(width: 30, height: 30, alignment: .center)
            .gesture(
                TapGesture()
                    .onEnded({ _ in
                        if person.phoneNumber.count >= 8 {
                            PersonSendSMS(person: person)
                        } else {
                            message = "Missing phonenumber"
                            isAlertActive.toggle()
                        }
                    })
            )
            .alert(Text("Phonenumber"), isPresented: $isAlertActive) {
                Button("OK", action: {})
            } message: {
                Text(message)
            }
    }
}
