//
//  CloudKitCabin.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import CloudKit
import SwiftUI

struct CloudKitCabin {
    
    var database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    struct RecordType {
        static let Cabin = "Cabin"
    }
    
    func saveCabin(_ cabin: Cabin) async throws {
        let cabinRecord = CKRecord(recordType: RecordType.Cabin)
        cabinRecord["firstName"] = cabin.firstName
        cabinRecord["lastName"] = cabin.lastName
        cabinRecord["fromDate"] = cabin.fromDate
        cabinRecord["toDate"] = cabin.toDate
        do {
            try await database.save(cabinRecord)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func existCabin(_ predicate: NSPredicate, _ cabin: Cabin) async throws -> Bool {
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for _ in result.0 {
                return true
            }
        } catch {
            throw error
        }
        return false
    }

    func getAllCabins() async throws -> [Cabin] {
        var cabins = [Cabin]()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            ///
            /// Slik finnes alle postene
            ///
            let result = try await database.records(matching: query)
            
            for record in result .matchResults {
                var cabin = Cabin(firstName: "",
                                  lastName: "",
                                  fromDate: 0,
                                  toDate: 0)
                ///
                /// Slik hentes de enkelte feltene ut:
                ///
                let cab  = try record.1.get()
                
                let id = record.0.recordName
                let recID = CKRecord.ID(recordName: id)
                
                let firstName = cab.value(forKey: "firstName") ?? ""
                let lastName = cab.value(forKey: "lastName") ?? ""
                let fromDate = cab.value(forKey: "fromDate") ?? 0
                let toDate = cab.value(forKey: "toDate") ?? 0
                cabin.recordID = recID
                cabin.firstName = firstName as! String
                cabin.lastName = lastName as! String
                cabin.fromDate = fromDate as! Int
                cabin.toDate = toDate as! Int
                
                cabins.append(cabin)
                cabins.sort(by: {$0.firstName < $1.firstName})
            }
            return cabins
        } catch {
            throw error
        }
    }
    
    func deleteOneCabin(_ recID: CKRecord.ID) async throws {
        do {
            try await database.deleteRecord(withID: recID)
        } catch {
            throw error
        }
    }

    func modifyCabin(_ cabin: Cabin) async throws {
        
        guard let recID = cabin.recordID else { return }
        
        do {
            let cabinRecord = CKRecord(recordType: RecordType.Cabin)
            cabinRecord["firstName"] = cabin.firstName
            cabinRecord["lastName"] = cabin.lastName
            cabinRecord["fromDate"] = cabin.fromDate
            cabinRecord["toDate"] = cabin.toDate
            do {
                let _ = try await database.modifyRecords(saving: [cabinRecord], deleting: [recID])
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
   
    @MainActor
    func getCabinRecordID(_ predicate: NSPredicate,_ cabin: Cabin) async throws -> CKRecord.ID? {
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                return CKRecord.ID(recordName: id)
            }
        } catch {
            throw error
        }
        return nil
    }
    
    func deleteAllCabins(_ predicate: NSPredicate, _ recID: CKRecord.ID) async throws {
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                let recID = CKRecord.ID(recordName: id)
                try await database.deleteRecord(withID: recID)
            }
        } catch {
            throw error
        }
    }

}
