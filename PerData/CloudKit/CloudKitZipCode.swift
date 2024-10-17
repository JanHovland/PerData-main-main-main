//
//  CloudKitZipCode.swift
//  PerData
//
//  Created by Jan Hovland on 29/10/2021.
//

import CloudKit
import OSLog
import SwiftUI

struct CloudKitZipCode {
    
    var database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    struct RecordType {
        static let ZipCode = "ZipCode"
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    @State private var message: String = ""
    
    /// MARK: - saving to CloudKit
    func saveZipCode(_ zipCode: ZipCode) async throws {
        let zipCodeRecord = CKRecord(recordType: RecordType.ZipCode)
        zipCodeRecord["postalNumber"] = zipCode.postalNumber as CKRecordValue
        zipCodeRecord["postalName"] = zipCode.postalName as CKRecordValue
        zipCodeRecord["municipalityNumber"] = zipCode.municipalityNumber as CKRecordValue
        zipCodeRecord["municipalityName"] = zipCode.municipalityName as CKRecordValue
        zipCodeRecord["category"] = zipCode.category as CKRecordValue
        do {
            try await database.save(zipCodeRecord)
        } catch {
            throw error
        }
    }
    
     
    func getAllZipCodes(_ predicate:  NSPredicate) async throws -> [ZipCode] {
        
        /// Legg merke til at City har bare store bokstaver
         
        var zipCode = [ZipCode]()
        let query = CKQuery(recordType: RecordType.ZipCode, predicate: predicate)
        do {
            ///
            /// Slik finnes alle postene
            ///
            let result = try await database.records(matching: query)

            for record in result.matchResults {
                var zipCode1 = ZipCode()
                ///
                /// Slik hentes de enkelte feltene ut:
                ///
                let zip  = try record.1.get()
                
                let id = record.0.recordName
                let recID = CKRecord.ID(recordName: id)
                
                let postNumber = zip.value(forKey: "postalNumber") ?? ""
                let postalName = zip.value(forKey: "postalName") ?? ""
                let municipalityNumber = zip.value(forKey: "municipalityNumber") ?? ""
                let municipalityName = zip.value(forKey: "municipalityName") ?? ""
                let category = zip.value(forKey: "category") ?? ""
                zipCode1.recordID = recID
                zipCode1.postalNumber = postNumber as! String
                zipCode1.postalName = postalName as! String
                zipCode1.municipalityNumber = municipalityNumber as! String
                zipCode1.municipalityName = municipalityName as! String
                zipCode1.category = category as! String
                zipCode.append(zipCode1)
                zipCode.sort(by: {$0.postalNumber < $1.postalNumber})
            }
            return zipCode
        } catch {
            throw error
        }
    }
    
    // MARK: - delete from CloudKit
    func deleteZipCode(_ recordID: CKRecord.ID) async throws {
        do {
            try await database.deleteRecord(withID: recordID)
        } catch {
            throw error
        }
    }
    
}


