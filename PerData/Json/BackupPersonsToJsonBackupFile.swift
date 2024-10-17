//
//  BackupPersonsToJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 24/11/2021.
//

import SwiftUI
import CloudKit

func backupPersonsToJsonBackupFile(jsonFile: String, persons: [Person])  -> LocalizedStringKey {
    
    /// Opprette en fil i Document directory
    /// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
    /// For å få tak i filen som blir opprette og kunne se denne i "Filer" på iPhone:
    ///     Legg til disse i Info.plist:
    ///     Application supports iTunes file sharing     YES
    ///     Supports opening documents in place        YES
    ///
    /// Dersom en skriver ut "", blankes innholdet ut.
    ///
    
    let url = getDocumentsDirectory().appendingPathComponent(jsonFile)
    print(url)
    let message = savePersonToJasonFile(url: url, persons: persons)
    return message
    
}

func getDocumentsDirectory() -> URL {
    /// Find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    /// Just send back the first one, which ought to be the only one
    return paths[0]
}

func savePersonToJasonFile(url: URL, persons: [Person]) -> LocalizedStringKey {
    var str = ""
    var message: LocalizedStringKey = ""
    
    /// Resetter innholdet Json filen
    do {
        let str = ""
        try str.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        let _ = error.localizedDescription
    }
    
    if persons.count > 0 {
        
        let max = persons.count
        var teller = 0
        
        /// Lagrer personene i Json filen
        
        /// Header

        do {
            let fileHandle = try FileHandle(forWritingTo: url)
            str = "["
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        } catch {
            return LocalizedStringKey(error.localizedDescription)
        }
        
        for person in persons {
            do {
                teller += 1
                let fileHandle = try FileHandle(forWritingTo: url)
                if teller < max {
                    str = formatJsonPerson(person: person) + ","
                } else {
                    str = formatJsonPerson(person: person)
                }
                let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                return LocalizedStringKey(error.localizedDescription)
            }
        }
        
        /// Footer
         
        do {
            let fileHandle = try FileHandle(forWritingTo: url)
            str = "\n]"
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        } catch {
            return LocalizedStringKey(error.localizedDescription)
        }
        
    } else {
        message = "The Person table in CloudKit is still empty.\nTry again in a litte while."
        return message
    }
    message = "The Person backup to Json is finished."
    return message
}

func formatJsonPerson(person: Person) -> String {
    var string = ""
    var string1 = ""
    var string2 = ""
    var string3 = ""
    var string4 = ""
    var string5 = ""
    var string6 = ""
    var string7 = ""
    var string8 = ""
    var string9 = ""
    var string10 = ""
    var string11 = ""
    var string12 = ""
    var string13 = ""
    var string14 = ""
    var string15 = ""
    var string16 = ""
    
    /// "\"" + UUID().uuidString + "\"" ----> "79587E0B-A7C2-41AF-B42E-934C223AC456"
    string1 = "\n\t{\n\t\t" + "\"" + "id" + "\"" + ": " + "\"" + UUID().uuidString + "\"" + ","
    string2 = "\n\t\t" + "\"" + "personData" + "\"" + " : {\n\t\t\t"
    string3 = "\"firstName\" : " + "\"" + person.firstName + "\",\n\t\t\t"
    string4 = "\"lastName\" : "  + "\"" + person.lastName  + "\"" + ",\n\t\t\t"
    if person.personEmail.count == 0 {
        string5 = "\"personEmail\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string5 = "\"personEmail\" : " + "\"" + person.personEmail + "\"" + ",\n\t\t\t"
    }
    if person.address.count == 0 {
        string6 = "\"address\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string6 = "\"address\" : " + "\"" + person.address + "\"" + ",\n\t\t\t"
    }
    if person.phoneNumber.count == 0 {
        string7 = "\"phoneNumber\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string7 = "\"phoneNumber\" : " + "\"" + person.phoneNumber + "\"" + ",\n\t\t\t"
    }
    if person.cityNumber.count == 0 {
        string8 = "\"cityNumber\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string8 = "\"cityNumber\" : " + "\"" + person.cityNumber + "\"" + ",\n\t\t\t"
    }
    if person.city.count == 0 {
        string9 = "\"city\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string9 = "\"city\" : " + "\"" + person.city + "\"" + ",\n\t\t\t"
    }
    if person.municipalityNumber.count == 0 {
        string10 = "\"municipalityNumber\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string10 = "\"municipalityNumber\" : " + "\"" + person.municipalityNumber + "\"" + ",\n\t\t\t"
    }
    if person.municipality.count == 0 {
        string11 = "\"municipality\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string11 = "\"municipality\" : " + "\"" + person.municipality + "\"" + ",\n\t\t\t"
    }
    string12 = "\"dateOfBirth\" : " + "\"" + "\(person.dateOfBirth as Any)" + "\"" + ",\n\t\t\t"
    if person.dateMonthDay.count == 0 {
        string13 = "\"dateMonthDay\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string13 = "\"dateMonthDay\" : " + "\"" + person.dateMonthDay + "\"" + ",\n\t\t\t"
    }
    string14 = "\"gender\" : " + "\(person.gender as Any)" + ",\n\t\t\t"
    
    if person.image == nil {
        string15 = "\"image\" : " + "\"" + " " + "\"" + "\n\t\t}"
    } else {
        string15 = "\"image\" : " + "\"" + "\(person.image! as UIImage)"  + "\"" + "\n\t\t}"
    }
    string16 = "\n\t}"
    string = string1 + string2 + string3 + string4 + string5 + string6 + string7 + string8 + string9 + string10 + string11 + string12 + string13 + string14 + string15 + string16
    return string
}

