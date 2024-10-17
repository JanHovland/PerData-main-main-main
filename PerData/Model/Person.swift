//
//  Person.swift
//  PerData
//
//  Created by Jan Hovland on 28/10/2021.
//

import SwiftUI
import CloudKit

struct Person: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var firstName: String = ""
    var lastName: String = ""
    var personEmail: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var cityNumber: String = ""
    var city: String = ""
    var municipalityNumber: String = ""
    var municipality: String = ""
    var dateOfBirth = Date()
    var dateMonthDay: String = ""        /// format      26.02.20   ==   dd.MM.yy   0226 == MMdd
    var gender: Int = 0
    var image: UIImage?
    var dead: Int = 0
}


class PersonEnvironment: ObservableObject {
    @Published var recordID: CKRecord.ID?
    @Published var name = ""
    @Published var email = "jan.hovland@lyse.net"
    @Published var passWord = "qwerty"
    @Published var image: UIImage?
}
 
class PersonInfo: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phoneNumber = ""
}

// MARK: - PersonElem
struct PersonElem : Codable, Identifiable {
    var id: String
    var personData: PersonDat
}

// MARK: - PersonDat
struct PersonDat: Codable {
    var firstName : String
    var lastName : String
    var personEmail : String
    var address : String
    var phoneNumber : String
    var cityNumber : String
    var city : String
    var municipalityNumber : String
    var municipality : String
    var dateOfBirth : String
    var dateMonthDay : String
    var gender : Int
    var image : String
}

