//
//  FindZipCode.swift
//  PerData
//
//  Created by Jan Hovland on 29/10/2021.
//

import SwiftUI
import CloudKit

struct FindZipCode: View {

    @Binding var city: String
    @Binding var cityNumber: String
    @Binding var municipalityNumber: String
    @Binding var municipality: String

    @Environment(\.presentationMode) var presentationMode

    @State private var zipCodes = [ZipCode]()
    @State private var selection = 0
    @State private var pickerVisible = false
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive = false
    @State private var indicatorShowing = false

    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
            Spacer(minLength: 40)
            Text("Select ZipCode")
                .font(.title)
            Text(city)
            Spacer()
            List {
                if zipCodes.count > 0 {
                    Picker(selection: $selection, label: EmptyView()) {
                        ForEach((0..<zipCodes.count), id: \.self) { ix in
                            HStack (alignment: .center) {
                                Text(zipCodes[ix].postalName).tag(ix)
                                Text(zipCodes[ix].postalNumber).tag(ix)
                            }
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                        /// Denne sørger for å vise det riktige "valget" pålinje 2
                        .id(UUID().uuidString)
                        .onTapGesture {
                            /// zipCodes blir resatt av: .onAppear
                            if zipCodes[selection].postalNumber.count > 0,
                               zipCodes[selection].municipalityNumber.count > 0,
                               zipCodes[selection].municipalityName.count > 0 {
                               city = zipCodes[selection].postalName
                               cityNumber = zipCodes[selection].postalNumber
                               municipalityNumber = zipCodes[selection].municipalityNumber
                               municipality = zipCodes[selection].municipalityName.lowercased()
                               municipality = municipality.capitalizingFirstLetter()
                            }
                            pickerVisible.toggle()
                            selection = 0
                            /// Avslutter bildet
                            presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationBarTitle("ZipCode", displayMode: .inline)
        .task {
            if city.count > 0 {
                indicatorShowing = true
                zipCodes = await findZipCode(city: city)
                if zipCodes.count == 0 {
                    title = LocalizedStringKey(city)
                    message = "Can not find \(city)"
                    isAlertActive.toggle()
                }
                indicatorShowing = false
            } else {
                title = "City"
                message = "Empty city name"
                isAlertActive.toggle()
            }
        }
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {
                presentationMode.wrappedValue.dismiss()
                
            })
        } message: {
            Text(message)
        }
        .overlay(
            HStack {
                VStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ReturnFromMenuView(text: "Modify person")
                    }
                    Spacer()
                }
                Spacer()
                
            }
            .padding(.leading,5)
        )
    }
    
}

/// Funksjon for å sette første bokstav til uppercase
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}


