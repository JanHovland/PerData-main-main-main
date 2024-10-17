//
//  Cabin.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI
import CloudKit

struct Cabin: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var firstName: String
    var lastName: String
    var fromDate: Int
    var toDate: Int
}

// MARK: - CabinElem
struct CabinElem : Codable, Identifiable {
    var id: String
    var cabinData: CabinData
}

// MARK: - CabinData
struct CabinData: Codable {
    var firstName: String
    var lastName: String
    var fromDate: Int
    var toDate: Int
}
