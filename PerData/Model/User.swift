//
//  User.swift
//  PerData
//
//  Created by Jan Hovland on 16/11/2021.
//

import SwiftUI
import CloudKit

class User: ObservableObject {
    @Published var recordID: CKRecord.ID?
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = "jan.hovland@lyse.net"
    @Published var passWord = "qwerty"
    @Published var image: UIImage?
}
