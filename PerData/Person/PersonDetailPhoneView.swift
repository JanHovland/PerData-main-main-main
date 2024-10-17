//
//  PersonDetailPhoneView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct PersonDetailPhoneView: View {
    var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var isAlertActive = false
    
    var body: some View {
        Image("phone")
        /// Formatet er : tel:<phone>
            .resizable()
            .frame(width: 30, height: 30, alignment: .center)
            .gesture(
                TapGesture()
                    .onEnded({_ in
                        if person.phoneNumber.count >= 8 {
                            /// 1: Eventuelle blanke tegn må fjernes
                            /// 2: Det ringes ved å kalle UIApplication.shared.open(url)
                            let prefix = "tel:"
                            let phoneNumber1 = prefix + person.phoneNumber
                            let phoneNumber = phoneNumber1.replacingOccurrences(of: " ", with: "")
                            guard let url = URL(string: phoneNumber) else { return }
                            UIApplication.shared.open(url)
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

