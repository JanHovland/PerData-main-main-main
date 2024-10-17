//
//  BackupUserRecordToJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 26/11/2021.
//

import SwiftUI
import CloudKit

func backupCabinsToJsonBackupFile(jsonFile: String, cabins: [Cabin])  -> LocalizedStringKey {
    
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
    let message = saveCabinToJasonFile(url: url, cabins: cabins)
    return message
}

func saveCabinToJasonFile(url: URL, cabins: [Cabin]) -> LocalizedStringKey {
    var str = ""
    var message: LocalizedStringKey = ""
    /// Resetter innholdet Json filen
    do {
        let str = ""
        try str.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        let _ = error.localizedDescription
    }
    if cabins.count > 0 {
        
        let max = cabins.count
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
        for cabin in cabins {
            do {
                teller += 1
                let fileHandle = try FileHandle(forWritingTo: url)
                if teller < max {
                    str = formatJsonCabin(cabin: cabin) + ","
                } else {
                    str = formatJsonCabin(cabin: cabin)
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
        message = "The Cabin table in CloudKit is still empty.\nTry again in a litte while."
        return message
    }
    message = "The Cabin backup to Json is finished."
    return message
}

func formatJsonCabin(cabin: Cabin) -> String {
    var string = ""
    var string1 = ""
    var string2 = ""
    var string3 = ""
    var string4 = ""
    var string5 = ""
    var string6 = ""
    var string7 = ""
 
    /// "\"" + UUID().uuidString + "\"" ----> "79587E0B-A7C2-41AF-B42E-934C223AC456"
    string1 = "\n\t{\n\t\t" + "\"" + "id" + "\"" + ": " + "\"" + UUID().uuidString + "\"" + ","
    string2 = "\n\t\t" + "\"" + "cabinData" + "\"" + " : {\n\t\t\t"
    string3 = "\"firstName\" : " + "\"" + cabin.firstName + "\",\n\t\t\t"
    string4 = "\"lastName\" : " + "\"" + cabin.lastName + "\",\n\t\t\t"
    string5 = "\"fromDate\" : " + "\(cabin.fromDate)" + ",\n\t\t\t"
    string6 = "\"toDate\" : " + "\(cabin.toDate)" + "\n\t\t}"
    string7 = "\n\t}"
    string = string1 + string2 + string3 + string4 + string5 + string6 + string7
    return string
}

