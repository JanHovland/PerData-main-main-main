//
//  PersonDetailCabinView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct PersonDetailCabinView: View {
    var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var isAlertActive = false
    
    enum SheetContent {
        case first
    }
    
    @State private var sheetContent: SheetContent = .first
    @State private var showSheet = false
    
    var body: some View {
        Image("Cabin")
            .resizable()
            .frame(width: 32, height: 32, alignment: .center)
            .cornerRadius(4)
            .gesture(
                TapGesture()
                    .onEnded({ _ in
                        if person.firstName.count > 1 {
                            sheetContent = .first
                            showSheet = true
                        } else {
                            message = "No name selected" 
                            isAlertActive.toggle()
                        }
                    })
            )
            .alert(Text("Cabin"), isPresented: $isAlertActive) {
                Button("OK", action: {})
            } message: {
                Text(message)
            }
            .sheet(isPresented: $showSheet, content: {
                switch sheetContent {
                case .first: CabinReservationView(person: person)
                }
            })
    }
}

