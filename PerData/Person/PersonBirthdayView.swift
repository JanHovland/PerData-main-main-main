//
//  PersonBirthdayView.swift
//  PerData
//
//  Created by Jan Hovland on 06/12/2021.
//

import SwiftUI

struct personBirthdayView: View {
    
    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var persons = [Person]()
    @State private var searchText: String = ""
    @State private var indicatorShowing = false
    @State private var predicate = NSPredicate(value: true)
    @State private var isAlertActive = false
    
    let barTitle: LocalizedStringKey = "Birthday"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(persons) {
                        person in
                        if searchText == "" || person.firstName.contains(searchText) {
                            NavigationLink(destination: PersonUpdateView(person: person)) {
                                showPersonBirthday(person: person)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
            } // VStack
            .padding(.top, 20)
            .refreshable {
                await refreshBirthDays()
            }
            .backToCaller("PersonOverView")
            .navigationBarTitle(barTitle, displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button (action: {
                        Task.init {
                            indicatorShowing = true
                            await refreshBirthDays()
                            indicatorShowing = false
                        }
                    }, label: {
                        Text("Refresh")
                    })
                }
            })
            
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search firstName")
        .onChange(of: searchText) { searchText, oldSearchText in
            self.searchText = searchText.capitalizingFirstLetter()
            predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "firstName BEGINSWITH %@", searchText)
            Task.init {
                indicatorShowing = true
                await refreshBirthDays()
                indicatorShowing = false
            }
        }
        .task {
            await refreshBirthDays()
        }
    }
    
    /// Rutine for å friske opp bildet
    func refreshBirthDays() async {
        /// Sletter alt tidligere innhold i person
        persons.removeAll()
        /// Fetch all persons from CloudKit
        /// Sletter alt tidligere innhold i persons
        /// Fetch all userRecords  from CloudKit
        var value: (LocalizedStringKey, [Person], [String])
        indicatorShowing = true
        await value = findPersons()
        if value.0 != "" {
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            persons = value.1
            persons.sort(by: {$0.dateMonthDay < $1.dateMonthDay})
            
        }
        indicatorShowing = false
    }
    
}
/// Et eget View for å vise person detail view
struct showPersonBirthday: View {
    
    var person: Person
    
    @State private var message: String = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive = false
    
    @State private var sendMail = false
    
    /* Dato formateringer:
     Wednesday, Feb 26, 2020            EEEE, MMM d, yyyy
     02/26/2020                         MM/dd/yyyy
     02-26-2020 12:30                   MM-dd-yyyy HH:mm
     Feb 26, 12:30 PM                   MMM d, h:mm a
     February 2020                      MMMM yyyy
     Feb 26, 2020                       MMM d, yyyy
     Wed, 26 Feb 2020 12:30:24 +0000    E, d MMM yyyy HH:mm:ss Z
     2020-02-26T12:30:24+0000           yyyy-MM-dd'T'HH:mm:ssZ
     26.02.20                           dd.MM.yy
     12:30:24.423                       HH:mm:ss.SSS
     */
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "dd. MMM"
        return formatter
    }()
    
    var age: String {
        /// Finner aktuell måned
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "yy"
        let year = Calendar.current.component(.year, from: currentDate)
        
        /// Finner måned fra personen sin fødselsdato
        let personDate = person.dateOfBirth
        let personFormatter = DateFormatter()
        personFormatter.dateFormat = "yy"
        let yearPerson = Calendar.current.component(.year, from: personDate)
        
        let ag = year - yearPerson
        
        if ag < 10 {
            return "  " + String(ag)
        } else {
            return String(ag)
        }
    }
    
    var colour: Color {
        /// Finner aktuell måned
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        let month = Calendar.current.component(.month, from: currentDate)
        
        /// Finner måned fra personen sin fødselsdato
        let personDate = person.dateOfBirth
        let personFormatter = DateFormatter()
        personFormatter.dateFormat = "MMMM"
        let monthPerson = Calendar.current.component(.month, from: personDate)
        
        /// Endrer bakgrunnsfarge dersom personen er født i inneværende måned
        if monthPerson == month {
            return Color(.systemGreen)
        }
        return Color(.clear)
    }
    
    var body: some View {
        HStack (spacing: 10) {
            if person.image != nil {
                Image(uiImage: person.image!)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .font(.system(size: 16, weight: .ultraLight))
                    .frame(width: 30, height: 30, alignment: .center)
            }
            Text("\(person.dateOfBirth, formatter: showPersonBirthday.taskDateFormat)")
                .background(colour)
                .font(.custom("Andale Mono", size: 16))
            Text(age)
                .foregroundColor(.accentColor)
                .font(.custom("Andale Mono", size: 16))
            Text(person.firstName)
                .font(Font.title2.weight(.ultraLight))
            Spacer(minLength: 5)
            Image("message")
            /// Formatet er : tel:<phone><&body>
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            if person.phoneNumber.count > 0 {
                                PersonSendSMS(person: person)
                            } else {
                                title = "Birthday"
                                message = "Missing phonenumber"
                                isAlertActive.toggle()
                            }
                        })
                )
        }
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }
    }
}



