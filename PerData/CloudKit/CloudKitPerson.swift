//
//  CloudKitPerson.swift
//  PerData
//
//  Created by Jan Hovland on 07/10/2021.
//

import CloudKit
import SwiftUI

//  Block comment : Cmd + ´ (foran backspace tasten)
//  Re-Indent     : Shift + Ctrl + Cmd + 8 (on number pad)

///
/// Ved å endre func savePerson(person: Person)  til:
///     func savePerson(_ person: Person)  kan den kalles slik:
///     savePerson(person) i stedet for save(person: person)
///

/// https://danielbernal.co/stretched-launch-screen-images-in-swiftui-the-fix/

struct CloudKitPerson {
    
    var database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    struct RecordType {
        static let Person = "Person"
    }
    
    ///
    /// MARK: - saving to CloudKit
    ///
    
    func savePerson(_ person: Person) async throws {
        let personRecord = CKRecord(recordType: RecordType.Person)
        personRecord["firstName"] = person.firstName
        personRecord["lastName"] = person.lastName
        personRecord["personEmail"] = person.personEmail
        personRecord["address"] = person.address
        personRecord["phoneNumber"] = person.phoneNumber
        personRecord["cityNumber"] = person.cityNumber
        personRecord["city"] = person.city
        personRecord["municipalityNumber"] = person.municipalityNumber
        personRecord["municipality"] = person.municipality
        personRecord["dateOfBirth"] = person.dateOfBirth
        personRecord["dateMonthDay"] = person.dateMonthDay
        personRecord["gender"] = person.gender
        personRecord["dead"] = person.dead

        if person.image != nil {
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let url = documentsPath?.appendingPathComponent("image.png")

            let imageData = person.image?.jpegData(compressionQuality: 0.01)
            try! imageData?.write(to: url!)
            personRecord["image"] = CKAsset(fileURL: url!)
        } else {
            personRecord["image"] = nil
        }
        
        do {
            try await database.save(personRecord)
        } catch {
            throw error
        }
    }
    
    func existPerson(_ person: Person) async throws -> Bool {
        let predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", person.firstName, person.lastName)
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
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
    
    func getAllPersons(_ predicate: NSPredicate) async throws -> ([Person], [String]) {
        var char = ""
        var persons = [Person]()
        var sectionHeader = [String]()
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
        do {
            ///
            /// Slik finnes alle postene
            ///
            let result  = try await database.records(matching: query)
            
            for record in result.matchResults {
                var person = Person()
                ///
                /// Slik hentes de enkelte feltene ut:
                ///
                let per  = try record.1.get()
                
                let id = record.0.recordName
                let recID = CKRecord.ID(recordName: id)
                
                let firstName = per.value(forKey: "firstName") ?? ""
                let lastName = per.value(forKey: "lastName") ?? ""
                let email = per.value(forKey: "personEmail") ?? ""
                let address = per.value(forKey: "address") ?? ""
                let phoneNumber = per.value(forKey: "phoneNumber") ?? ""
                let cityNumber = per.value(forKey: "cityNumber") ?? ""
                let city = per.value(forKey: "city") ?? ""
                let municipalityNumber = per.value(forKey: "municipalityNumber") ?? ""
                let municipality = per.value(forKey: "municipality") ?? ""
                let dateOfBirth = per.value(forKey: "dateOfBirth") ?? Date()
                let dateMonthDay = per.value(forKey: "dateMonthDay") ?? ""
                let gender = per.value(forKey: "gender") ?? 0
                let dead = per.value(forKey: "dead") ?? 0
                if let image = per.value(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        person.recordID = recID
                        person.firstName = firstName as! String
                        person.lastName = lastName as! String
                        person.personEmail = email as! String
                        person.address = address as! String
                        person.phoneNumber = phoneNumber as! String
                        person.cityNumber =  cityNumber as! String
                        person.city = city as! String
                        person.municipalityNumber = municipalityNumber as! String
                        person.municipality = municipality as! String
                        person.dateOfBirth = dateOfBirth as! Date
                        person.dateMonthDay = dateMonthDay as! String
                        person.gender = gender as! Int
                        person.image = image
                        person.dead = dead as! Int
                    }
                } else {
                    person.recordID = recID
                    person.firstName = firstName as! String
                    person.lastName = lastName as! String
                    person.personEmail = email as! String
                    person.address = address as! String
                    person.phoneNumber = phoneNumber as! String
                    person.cityNumber =  cityNumber as! String
                    person.city = city as! String
                    person.municipalityNumber = municipalityNumber as! String
                    person.municipality = municipality as! String
                    person.dateOfBirth = dateOfBirth as! Date
                    person.dateMonthDay = dateMonthDay as! String
                    person.gender = gender as! Int
                    person.image = nil
                    person.dead = dead as! Int
                }
                
                char = String(person.firstName.prefix(1))
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
 
                persons.append(person)
                persons.sort(by: {$0.firstName < $1.firstName})
            }
            return (persons, sectionHeader)
        } catch {
            throw error
        }
    }
    
    func deleteOnePerson(_ recID: CKRecord.ID) async throws {
        do {
            try await database.deleteRecord(withID: recID)
        } catch {
            throw error
        }
    }
        
    func modifyPerson(_ person: Person, _ newImage: Bool) async throws {
        
        guard let recID = person.recordID else { return }
        
        do {
            let personRecord = CKRecord(recordType: RecordType.Person)
            personRecord["firstName"] = person.firstName
            personRecord["lastName"] = person.lastName
            personRecord["personEmail"] = person.personEmail
            personRecord["address"] = person.address
            personRecord["phoneNumber"] = person.phoneNumber
            personRecord["cityNumber"] = person.cityNumber
            personRecord["city"] = person.city
            personRecord["municipalityNumber"] = person.municipalityNumber
            personRecord["municipality"] = person.municipality
            personRecord["dateOfBirth"] = person.dateOfBirth
            personRecord["dateMonthDay"] = person.dateMonthDay
            personRecord["gender"] = person.gender
            personRecord["dead"] = person.dead

            if newImage {
                if person.image != nil {
                    let fileManager = FileManager.default
                    let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                    let url = documentsPath?.appendingPathComponent("image.png")
                    let imageData = person.image?.jpegData(compressionQuality: 0.01)
                    try! imageData?.write(to: url!)
                    personRecord["image"] = CKAsset(fileURL: url!)
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
                        personRecord["image"] = CKAsset(fileURL: url!)

                    }
                }
               
            }
            do {
                let _ = try await database.modifyRecords(saving: [personRecord], deleting: [recID])
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func getPersonRecordID(_ person: Person) async throws -> CKRecord.ID? {
        let predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", person.firstName, person.lastName)
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.matchResults {
                let id = res.0.recordName
                return CKRecord.ID(recordName: id)
            }
        } catch {
            throw error
        }
        return nil
    }

    func deleteAllPersons(_ recID: CKRecord.ID) async throws {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.Person, predicate: predicate)
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
