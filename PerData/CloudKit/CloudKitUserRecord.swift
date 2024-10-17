//
//  CloudKitUserRecord.swift
//  PerData
//
//  Created by Jan Hovland on 16/11/2021.
//

import SwiftUI
import CloudKit

//  Block comment : Cmd + ´ (foran backspace tasten)
//  Re-Indent     : Shift + Ctrl + Cmd + 8 (on number pad)

/// https://danielbernal.co/stretched-launch-screen-images-in-swiftui-the-fix/

struct CloudKitUserRecord {
    
    var database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    struct RecordType {
        static let UserRecord = "UserRecord"
    }
    
    ///
    /// MARK: - saving to CloudKit
    ///
    
    func saveUserRecord(_ userRecord: UserRecord) async throws {
        let userRec = CKRecord(recordType: RecordType.UserRecord)
        userRec["firstName"] = userRecord.firstName
        userRec["lastName"] = userRecord.lastName
        userRec["email"] = userRecord.email
        userRec["passWord"] = userRecord.passWord
        
        if userRecord.image != nil {
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let url = documentsPath?.appendingPathComponent("image.png")

            let imageData = userRecord.image?.jpegData(compressionQuality: 0.01)
            try! imageData?.write(to: url!)
            userRec["image"] = CKAsset(fileURL: url!)
        } else {
            userRec["image"] = nil
        }
        
        do {
            try await database.save(userRec)
        } catch {
            throw error
        }
    }
    
    func existUserRecord(_ userRecord: UserRecord) async throws -> (Bool, Any?) {
        let predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", userRecord.firstName, userRecord.lastName)
        let query = CKQuery(recordType: RecordType.UserRecord, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                let recID = CKRecord.ID(recordName: id)
                let per = try await database.record(for: recID)
                let image = per.value(forKey: "image") ?? nil
                
                return (true, image as Any?)
            }
        } catch {
            throw error
        }
        return (false, nil)
    }
    
    func getAllUserRecords(_ predicate: NSPredicate) async throws -> ([UserRecord], [String]) {
        var char = ""
        var userRecords = [UserRecord]()
        var sectionHeader = [String]()
        let query = CKQuery(recordType: RecordType.UserRecord, predicate: predicate)
        do {
            ///
            /// Slik finnes alle postene
            ///
            let result = try await database.records(matching: query)
            
            for record in result .matchResults {
                var userRecord = UserRecord(firstName: "",
                                            lastName: "",
                                            email: "",
                                            passWord: "",
                                            image: nil)
                ///
                /// Slik hentes de enkelte feltene ut:
                ///
                let user  = try record.1.get()
                
                let id = record.0.recordName
                let recID = CKRecord.ID(recordName: id)
                
                let firstName = user.value(forKey: "firstName") ?? ""
                let lastName = user.value(forKey: "lastName") ?? ""
                let email = user.value(forKey: "email") ?? ""
                let passWord = user.value(forKey: "passWord") ?? ""
                if let image = user.value(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        userRecord.recordID = recID
                        userRecord.firstName = firstName as! String
                        userRecord.lastName = lastName as! String
                        userRecord.email = email as! String
                        userRecord.passWord = passWord  as! String
                        userRecord.image = image
                    }
                } else {
                    userRecord.recordID = recID
                    userRecord.firstName = firstName as! String
                    userRecord.lastName = lastName as! String
                    userRecord.email = email as! String
                    userRecord.passWord = passWord  as! String
                    userRecord.image = nil
                }
                
                char = String(userRecord.firstName.prefix(1))
                /// Oppdatere sectionHeader[]
                if sectionHeader.contains(char) == false {
                    sectionHeader.append(char)
                    /// Dette må gjøre for å få sectionHeader riktig sortert
                    /// Standard sortering gir ikke norsk sortering
                    let region = NSLocale.current.region?.identifier.lowercased() // Returns the local region
                    let language = Locale(identifier: region!)
                    let sectionHeader1 = sectionHeader.sorted {
                        $0.compare($1, locale: language) == .orderedAscending
                    }
                    sectionHeader = sectionHeader1
                }
 
                userRecords.append(userRecord)
                userRecords.sort(by: {$0.firstName < $1.firstName})
            }
            return (userRecords, sectionHeader)
        } catch {
            throw error
        }
    }
    
    func deleteOneUserRecord(_ recID: CKRecord.ID) async throws {
        do {
            try await database.deleteRecord(withID: recID)
        } catch {
            throw error
        }
    }
        
    func modifyUserRecord(_ userRecord: UserRecord, _ newImage: Bool) async throws {
        
        guard let recID = userRecord.recordID else { return }
        
        do {
            let userRec = CKRecord(recordType: RecordType.UserRecord)
            userRec["firstName"] = userRecord.firstName
            userRec["lastName"] = userRecord.lastName
            userRec["email"] = userRecord.email
            userRec["passWord"] = userRecord.passWord
            
            if newImage {
                if userRecord.image != nil {
                    let fileManager = FileManager.default
                    let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                    let url = documentsPath?.appendingPathComponent("image.png")
                    let imageData = userRecord.image?.jpegData(compressionQuality: 0.01)
                    try! imageData?.write(to: url!)
                    userRec["image"] = CKAsset(fileURL: url!)
                }
            } else {
                
                ///
                /// Finn det gamle person sitt Image
                ///
               
                let per = try await database.record(for: recID)
                if let image = per.value(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        let fileManager = FileManager.default
                        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                        let url = documentsPath?.appendingPathComponent("image.png")
                        let imageData = image?.jpegData(compressionQuality: 0.01)
                        try! imageData?.write(to: url!)
                        userRec["image"] = CKAsset(fileURL: url!)
                    }
                }
            }
            do {
                let _ = try await database.modifyRecords(saving: [userRec], deleting: [recID])
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func getUserRecordRecordID(_ userRecord: UserRecord) async throws -> CKRecord.ID? {
        let predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", userRecord.firstName, userRecord.lastName)
        let query = CKQuery(recordType: RecordType.UserRecord, predicate: predicate)
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

    func deleteAllRecords(_ recID: CKRecord.ID) async throws {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.UserRecord, predicate: predicate)
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

    func getUserRecord(_ predicate: NSPredicate) async throws -> UserRecord {
        let query = CKQuery(recordType: RecordType.UserRecord, predicate: predicate)
        var userRecord = UserRecord(firstName: "",
                                    lastName: "",
                                    email: "",
                                    passWord: "",
                                    image: nil)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                let recID = CKRecord.ID(recordName: id)
                let per = try await database.record(for: recID)
                
                let firstName = per.value(forKey: "firstName") ?? ""
                let lastName = per.value(forKey: "lastName") ?? ""
                let email = per.value(forKey: "email") ?? ""
                let passWord = per.value(forKey: "passWord") ?? ""
                
                if let image = per.value(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        userRecord.recordID = recID
                        userRecord.firstName = firstName as! String
                        userRecord.lastName = lastName as! String
                        userRecord.email = email as! String
                        userRecord.passWord = passWord as! String
                        userRecord.image = image
                    }
                } else {
                    userRecord.recordID = recID
                    userRecord.firstName = firstName as! String
                    userRecord.lastName = lastName as! String
                    userRecord.email = email as! String
                    userRecord.passWord = passWord as! String
                    userRecord.image = nil
                }
            }
            return userRecord
        } catch {
            throw error
        }
    }

    
    
}
