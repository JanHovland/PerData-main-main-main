//
//  CabinReservationView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct CabinReservationView: View {
    var person: Person
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: LocalizedStringKey = ""
    @State private var message: LocalizedStringKey = ""
    @State private var hudMessage: String = ""
    @State private var indicatorShowing = false
    @State private var fromDatePicker = Date()
    @State private var toDatePicker = Date()
    @State private var saveCabinReservation = false

    @State private var cabin = Cabin(firstName: "",
                                     lastName: "",
                                     fromDate: 0,
                                     toDate: 0)
    
    @State private var cabinReservation: LocalizedStringKey = "Cabin reservation"
    
    @State private var isAlertActive = false

    enum SheetContent {
        case first
    }
    
    var body: some View {
        HStack {
            Button(action: {
                /// Rutine for å returnere til personoversikten
                presentationMode.wrappedValue.dismiss()
            }, label: {
                ReturnFromMenuView(text: "PersonOverView")
            })
            Spacer()
            Text(cabinReservation)
            Spacer()
            Button(action: {
                /// Rutine for å lagre reservasjonen
                cabin.fromDate =  Int(DateToInt(date: fromDatePicker))
                cabin.toDate =  Int(DateToInt(date: toDatePicker))
                Task.init {
                  await SaveCabinReservation(cabin: cabin)
                }
            }, label: {
                Text("Store")
                    .font(Font.headline.weight(.light))
            })
        }
        .padding()
        VStack {
            Form {
                Text(cabin.firstName)
                    .font(Font.title.weight(.light))
                Text(cabin.lastName)
                    .font(Font.title.weight(.light))
                DatePicker(
                    String(localized: "From date"),
                    selection: $fromDatePicker,
                    displayedComponents: [.date]
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.top, 20)
                
                DatePicker(
                    String(localized: "To date"),
                    selection: $toDatePicker,
                    displayedComponents: [.date]
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .task {
            cabin.firstName = person.firstName
            cabin.lastName = person.lastName
        }
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }
    }
    
    @MainActor
    func SaveCabinReservation(cabin: Cabin) async {
        let from = cabin.fromDate
        let to = cabin.toDate
        if from <= to {
            if cabin.firstName.count > 0 {
                var value : (LocalizedStringKey, Bool)
                let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@ AND fromDate == %i AND toDate == %i", cabin.firstName, cabin.lastName, cabin.fromDate as CVarArg, cabin.toDate as CVarArg)
                value = await cabinExist(predicate, cabin)
                if value.0 != "" {
                    message = value.0
                    title = "Error Cabin reservation"
                    isAlertActive.toggle()
                } else {
                    if value.1 == true {
                        message = "This record was saved earlier"
                        title = "Cabin reservation"
                        isAlertActive.toggle()
                    } else {
                        await message = saveCabin(cabin)
                        title = "Cabin reservation saved"
                        isAlertActive.toggle()
                    }
                }
            } else {
                title = "Cabin reservation"
                message = "Name must contain a value."
                isAlertActive.toggle()
            }
        } else {
            title = "From date / To date"
            message = "From date must be earlier than To date."
            isAlertActive.toggle()
        }
    }
    
}

///
/// Usage:  let fromDate = Date()
/// let a = DateToInt(date: fromDate)
///

func DateToInt (date: Date) -> Int64 {
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    // Set Date Format
    dateFormatter.dateFormat = "YYYYMMdd"
    return Int64(Int(dateFormatter.string(from: date)) ?? 0)
}

