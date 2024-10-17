//
//  UserRecordDetailView.swift
//  PerData
//
//  Created by Jan Hovland on 22/11/2021.
//

import SwiftUI
import CloudKit

struct UserRecordDetailView: View {
    
    @State  var userRecord: UserRecord
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showImage = false
    @State private var isAlertActive = false
    @State private var indicatorShowing = false
    @State private var modifyImage = false
    
    @State private var title: LocalizedStringKey = ""
    @State private var message: LocalizedStringKey = ""
    
    @State private var image = UIImage()
    
    @State private var recordID: CKRecord.ID?
    
    var body: some View {
        VStack {
            ZStack {
                if  userRecord.image != nil {
                    Image(uiImage: userRecord.image!)
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .onTapGesture {
                            showImage.toggle()
                            modifyImage = true
                        }
                } else {
                    ZStack {
                        Text("Select\nimage")
                            .font(Font.footnote.weight(.medium))
                            .foregroundColor(.green)
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
            }
            .padding(.top, 70)
            .padding(.bottom, 40)
            .sheet(isPresented: $showImage, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image, image: $userRecord.image)
            })
            VStack {
                HStack {
                    Text("FirstName")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 10)
                    Text(userRecord.firstName)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.leading, 8)
                .padding(.bottom, 10)
                HStack {
                    Text("LastName")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 10)
                    Text(userRecord.lastName)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.leading, 8)
                .padding(.bottom, 10)
                HStack {
                    Spacer()
                    Text("email")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 10)
                    TextField("Enter email", text: $userRecord.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.leading, 24)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                HStack {
                    Spacer()
                    Text("Password")
                        .foregroundColor(.accentColor)
                        .padding(.trailing, 10)
                    SecureField("Enter passWord", text: $userRecord.passWord)
                        .padding(.leading, 13)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            .padding(.leading, 50)
            Spacer()
        }
        .navigationBarTitle("User Details", displayMode: .inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "ellipsis.circle" ) // Text("_Cho<#T##String#>ose_")
                    .foregroundColor(.accentColor)
                    .font(Font.body.weight(.regular))
                    .contextMenu {
                        Button {
                            Task.init {
                                if userRecord.firstName.count > 0,
                                   userRecord.lastName.count > 0,
                                   userRecord.email.count > 0,
                                   userRecord.passWord.count > 0 {
                                    indicatorShowing = true
                                    var value: (LocalizedStringKey, CKRecord.ID?)
                                    await value = userRecordRecordID(userRecord)
                                    if value.0 != "" {
                                        message = value.0
                                        title = "Error message from the Server"
                                        isAlertActive.toggle()
                                    } else {
                                        if value.1 == nil {
                                            await message = saveUserRecord(userRecord)
                                            title = "Save"
                                            isAlertActive.toggle()
                                        } else {
                                            userRecord.recordID = value.1
                                            await message = modifyUserRecord(userRecord, modifyImage)
                                            title = "Modify"
                                            isAlertActive.toggle()
                                        }
                                    }
                                } else {
                                    title = "Missing value(s)"
                                    message = "All the fields must have a value"
                                    isAlertActive.toggle()
                                }
                            }
                        } label: {
                            Label("Update", systemImage: "square.and.pencil")
                            
                        }
                        
                        Button {
                            print("Delete userRecord")
                            Task.init {
                                recordID = userRecord.recordID
                                await message = deleteUserRecord(recordID!)
                                userRecord = UserRecord(firstName: "",
                                                        lastName: "",
                                                        email: "",
                                                        passWord: "",
                                                        image: nil)
                                title = "Delete an UserRecord"
                                isAlertActive.toggle()
                            }
                        } label: {
                            Label("Delete", systemImage: "square.and.pencil")
                        }
                        
                    }
            }
        })       
        .alert(title, isPresented: $isAlertActive) {
            Button("OK", action: {})
        } message: {
            Text(message)
        }
    }
}


