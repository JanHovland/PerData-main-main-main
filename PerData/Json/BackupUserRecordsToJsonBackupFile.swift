//
//  BackupUserRecordToJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 26/11/2021.
//

import SwiftUI
import CloudKit

func backupUserRecordsToJsonBackupFile(jsonFile: String, userRecords: [UserRecord])  -> LocalizedStringKey {
    
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
    let message = saveUserRecordToJasonFile(url: url, userRecords: userRecords)
    return message
}

func saveUserRecordToJasonFile(url: URL, userRecords: [UserRecord]) -> LocalizedStringKey {
    var str = ""
    var message: LocalizedStringKey = ""
    /// Resetter innholdet Json filen
    do {
        let str = ""
        try str.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        let _ = error.localizedDescription
    }
    if userRecords.count > 0 {
        
        let max = userRecords.count
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
        for userRecord in userRecords {
            do {
                teller += 1
                let fileHandle = try FileHandle(forWritingTo: url)
                if teller < max {
                    str = formatJsonUserRecord(userRecord: userRecord) + ","
                } else {
                    str = formatJsonUserRecord(userRecord: userRecord)
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
        message = "The userRecord table in CloudKit is still empty.\nTry again in a litte while."
        return message
    }
    message = "The userRecord backup to Json is finished."
    return message
}

func formatJsonUserRecord(userRecord: UserRecord) -> String {
    var string = ""
    var string1 = ""
    var string2 = ""
    var string3 = ""
    var string4 = ""
    var string5 = ""
    var string6 = ""
    var string7 = ""
    var string8 = ""

    /// "\"" + UUID().uuidString + "\"" ----> "79587E0B-A7C2-41AF-B42E-934C223AC456"
    string1 = "\n\t{\n\t\t" + "\"" + "id" + "\"" + ": " + "\"" + UUID().uuidString + "\"" + ","
    string2 = "\n\t\t" + "\"" + "userRecordData" + "\"" + " : {\n\t\t\t"
    string3 = "\"firstName\" : " + "\"" + userRecord.firstName + "\",\n\t\t\t"
    string4 = "\"lastName\" : " + "\"" + userRecord.lastName + "\",\n\t\t\t"
    if userRecord.email.count == 0 {
        string5 = "\"email\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string5 = "\"email\" : " + "\"" + userRecord.email + "\"" + ",\n\t\t\t"
    }
    if userRecord.passWord.count == 0 {
        string6 = "\"passWord\" : " + "\"" + " " + "\"" + ",\n\t\t\t"
    } else {
        string6 = "\"passWord\" : " + "\"" + userRecord.passWord + "\"" + ",\n\t\t\t"
    }
    if userRecord.image == nil {
        string7 = "\"image\" : " + "\"" + " " + "\"" + "\n\t\t}"
    } else {
        string7 = "\"image\" : " + "\"" + "\(userRecord.image! as UIImage)"  + "\"" + "\n\t\t}"
    }
    string8 = "\n\t}"
    string = string1 + string2 + string3 + string4 + string5 + string6 + string7 + string8
    return string
}

