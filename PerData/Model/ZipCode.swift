//
//  ZipCode.swift
//  PerData
//
//  Created by Jan Hovland on 29/10/2021.
//

import SwiftUI
import CloudKit

/// struct ZipCoder: Identifiable {
struct ZipCode: Identifiable {
   var id = UUID()
   var recordID: CKRecord.ID?
   var postalNumber: String = ""
   var postalName: String = ""
   var municipalityNumber: String = ""
   var municipalityName: String = ""
   var category: String = ""
}
