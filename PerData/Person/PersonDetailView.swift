//
//  PersonDetailView.swift
//  PerData
//
//  Created by Jan Hovland on 26/10/2021.
//

/// https://serialcoder.dev/?s=sheet
/// https://sarunw.com/posts/how-to-present-alert-in-swiftui-ios15/
/// https://sarunw.com/posts/how-to-show-multiple-alerts-on-the-same-view-in-swiftui/

import SwiftUI
import CloudKit

struct PersonDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var person: Person
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                
                if person.dead > 0 {
                    Image("dead")
                        .resizable()
                        .frame(width: 12, height: 34, alignment: .center)
                }
                
                if person.image != nil {
                    Image(uiImage: person.image!)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .font(.system(size: 16, weight: .ultraLight, design: .serif))
                        .frame(width: 50, height: 50, alignment: .center)
                }
                VStack (alignment: .leading) {
                    Text(person.firstName)
                    Text(person.lastName)
                }
                .dynamicTypeSize(.xSmall ... .small)
                .foregroundColor(.purple)
                Spacer()
            }
            Text(person.dateOfBirth.formatDate())
            Text(person.address)
            
            Text(person.cityNumber + " " + person.city)
                .padding(.bottom, 5)
        }
    }
}

/// "29. 05 1977" -> 1977-05-29 00:00:00 +0000
/// Månedene må være på engelsk

/// Dato formateringer:
/// Wednesday, Feb 26, 2020                EEEE, MMM d, yyyy
/// 02/26/2020                                        MM/dd/yyyy
/// 02-26-2020 12:30                              MM-dd-yyyy HH:mm
/// Feb 26, 12:30 PM                              MMM d, h:mm a
/// February 2020                                   MMMM yyyy
/// Feb 26, 2020                                      MMM d, yyyy
/// Wed, 26 Feb 2020 12:30:24 +0000    E, d MMM yyyy HH:mm:ss Z
/// 2020-02-26T12:30:24+0000               yyyy-MM-dd'T'HH:mm:ssZ
/// 26.02.20                                             dd.MM.yy
/// 12:30:24.423                                      HH:mm:ss.SSS

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd. MMMM yyyy")
        return dateFormatter.string(from: self)
    }
}

struct ReturnFromMenuView: View {
    var text: LocalizedStringKey
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 11, height: 18, alignment: .center)
            Text(text)
        }
        .foregroundColor(.none)
        .font(Font.headline.weight(.regular))
    }
}
