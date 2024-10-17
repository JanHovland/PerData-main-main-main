//
//  PersonSendEmailView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

import SwiftUI
import MessageUI

struct PersonSendEmailView: View {
 
    var person: Person
    
    @Environment(\.presentationMode) var presentationMode

    
    @State var isShowingMailView = false
    @State var toRecipients: [String] = []
    @State var subject: String = ""
    @State var name: String = ""
    @State var messageBody: String = ""
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        VStack {
            if MFMailComposeViewController.canSendMail() {
                Button(action: {
                    toRecipients = [person.personEmail ]
                    subject = "Birthday greetings"
                    name = person.firstName
                    let message = "Congratulation so much on your birthday, "
                    messageBody = message + name + ",🇳🇴 😀"
                    isShowingMailView.toggle()
                }, label: {
                    Image(systemName: "envelope.fill")
                        .imageScale(.large)
                    Text("Show mail view")
                })
                .foregroundColor(Color.gray)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            } else {
                ErrorMail()
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.none)
                    })
                    .padding(.leading, 280)
                    .padding(.top, -250)
                    Spacer()
                }
            }
        )
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: $isShowingMailView,
                     toRecipients: $toRecipients,
                     subject: $subject,
                     messageBody: $messageBody,
                     result: $result)
        }
    }
    
}

struct ErrorMail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ReturnFromMenuView(text: "PersonOverView")
                }
                Spacer()
            }
            .padding()
            VStack {
                Text("Error eMail")
                    .font(Font.largeTitle.weight(.bold))
                Spacer()
                Text("Can't send emails from this device")
                Spacer()
            }
        }
        
    }
}

