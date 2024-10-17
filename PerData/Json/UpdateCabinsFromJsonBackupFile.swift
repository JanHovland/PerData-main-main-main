//
//  UpdateCabinsFromJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 28/11/2021.
//

import SwiftUI
import CloudKit

let jsonCabinFile = "CabinBackup.json"

private var message: LocalizedStringKey = ""

@MainActor
func updateCabinsFromJsonBackupFile() async -> LocalizedStringKey {
    
    var cabinElem : [CabinElem] = []
    var counter = 0
    
    var message: LocalizedStringKey = ""
    var cabin = Cabin(firstName: "",
                      lastName: "",
                      fromDate: 0,
                      toDate: 0)
    ///
    ///Leser inn fra Json til [CabinElem]
    ///
    if let url = Bundle.main.url(forResource: jsonCabinFile, withExtension: nil) {
        print(url)
        if let data = try? Data(contentsOf: url) {
            let jsondecoder = JSONDecoder()
            do{
                let result = try jsondecoder.decode([CabinElem].self, from: data)
                cabinElem = result
            }
            catch {
                message = "Error trying parse Json file"
                return message
            }
        }
    } else {
        message =  "Unknown Json file"
        return message
    }
    ///
    ///Lagre userRecord i UserRecord  tabellen
    ///
    for index in 0..<cabinElem.count {
        cabin = Cabin(
            firstName: cabinElem[index].cabinData.firstName,
            lastName: cabinElem[index].cabinData.lastName,
            fromDate: cabinElem[index].cabinData.fromDate,
            toDate: cabinElem[index].cabinData.toDate)
        ///
        /// Sjekk om hyttereservasjonen finnes
        ///
        var value : (LocalizedStringKey, Bool)
        let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@ AND fromDate == %i AND toDate == %i", cabin.firstName, cabin.lastName, cabin.fromDate as CVarArg, cabin.toDate as CVarArg)
        value = await cabinExist(predicate, cabin)
        if value.0 != "" {
            ///
            ///Feilmelding
            ///
            message = value.0
            return message
        } else {
            if value.1 == true { // userRecord finnes fra før
                /// Finn recordID for cabin som **finnes** fra før
                var valueID: (LocalizedStringKey, CKRecord.ID?)
                await valueID = cabinRecordID(predicate, cabin)
                if valueID.0 != "" {
                    message = value.0
                    return message
                } else {
                    cabin.recordID = valueID.1
                    await message = modifyCabin(cabin)
                }
            } else { /// userRecird finnes **ikke** fra før
                await message = saveCabin(cabin)
            }
            counter += 1
         }
    }
    
    message = LocalizedStringKey("Number of userRecords saved/modified from the Json backup file: \(counter)")
    return message
}


