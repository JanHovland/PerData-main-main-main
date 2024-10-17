//
//  PersonNewView.swift
//  PerData
//
//  Created by Jan Hovland on 27/10/2021.
//

import SwiftUI
import CloudKit

///
/// https://developer.apple.com/videos/play/wwdc2021/10023/
/// This one is about focus
///
/// https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
///

struct PersonNewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State         var person: Person
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var isAlertActive = false
    @State private var image = UIImage()
    @State private var saveImage: Bool = false
    
    @State private var showImage = false
    @State private var showZipCode = false
    @State private var modifyImage = false

    var genders = [String(localized: "Man"),
                   String(localized: "Woman")]
    
    var body: some View {
        NavigationView {
            VStack {
                
                ///
                /// VStack kan kun inneholde 10 elementer,
                /// derfor må Group benyttes
                
                Group {
                    HStack (alignment: .center) {
                        
                        ///
                        /// ZStack legger bildene oppå hverandre
                        ///
                        
                        ZStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .font(Font.title.weight(.ultraLight))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .foregroundColor(Color.indigo)
                                .opacity(1.00)
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .onTapGesture {
                                    showImage.toggle()
                                    modifyImage = true
                                }
                        }
                        .sheet(isPresented: $showImage, content: {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, image: $person.image)
                        })

                    }
                    TextField("FirstName", text: $person.firstName)
                        .autocapitalization(.words)
                    TextField("LastName", text: $person.lastName)
                        .autocapitalization(.words)
                    TextField("Email", text: $person.personEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Address", text: $person.address)
                        .autocapitalization(.words)
                    TextField("Phonenumber", text: $person.phoneNumber)
                }
                Group {
                    HStack (alignment: .center, spacing: 10) {
                        TextField("Citynumber", text: $person.cityNumber)
                            .keyboardType(.numberPad)
                        TextField("City", text: $person.city)
                            .autocapitalization(.words)
                        VStack {
                            Button {
                                saveImage.toggle()
                                showZipCode = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.blue)
                                    .font(.title)
                            }
                            .sheet(isPresented: $showZipCode, content: {
                                 FindZipCode(city: $person.city,
                                                cityNumber: $person.cityNumber,
                                                municipalityNumber: $person.municipalityNumber,
                                                municipality: $person.municipality)
                            })
                        }
                    }
                    HStack (alignment: .center, spacing: 10) {
                        TextField("Municipality number", text: $person.municipalityNumber)
                            .keyboardType(.numberPad)
                        TextField("Municipality", text: $person.municipality)
                            .autocapitalization(.none)
                            .autocapitalization(.words)
                    }
                    DatePicker(
                        selection: $person.dateOfBirth,
                        // in: ...dato,                  /// Uten in: -> ingen begrensning på datoutvalg
                        displayedComponents: [.date],
                        label: {
                            Text("Date of birth")
                        })
                        .padding(.leading, 10)
                    /// Returning an integer 0 == "Man" 1 == "Women
                    InputGender(heading: "Gender",
                                genders: genders,
                                value: $person.gender)
                }
                Spacer()
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .navigationBarTitle("New person", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ControlGroup {
                        Button(action: {
                            if person.firstName.count > 0,
                               person.lastName.count > 0 {
                                
                                ///
                                /// Sjekk om posten finnes i CloudKit og save eller modify
                                ///
                                
                                Task.init {
                                    await FindPersonRecordIdSave(person: person)
                               }
                            } else {
                                title = "Missing values."
                                message = "First- and LastName must both have values."
                                isAlertActive.toggle()
                            }
                            
                        }, label: {
                            Text("Save")
                        })
                        
                            .alert(title, isPresented: $isAlertActive) {
                                Button("OK", action: {})
                            } message: {
                                Text(message)
                            }
                    }
                    .controlGroupStyle(.navigation)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    ControlGroup {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ReturnFromMenuView(text: "PersonOverView")
                        }
                    }
                    .controlGroupStyle(.navigation)
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @MainActor
    func FindPersonRecordIdSave(person: Person) async {
        var value: (LocalizedStringKey, CKRecord.ID?)
        await value = personRecordID(person)
        if value.0 != "" {
            ///
            ///Feilmelding
            ///
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            if value.1 == nil {
                await message = save(person)
                title = "Save"
                isAlertActive.toggle()
            } else {
                message = "This person exists in CloudKit "
                title = "Modify"
                isAlertActive.toggle()
            }
        }
    }

}
