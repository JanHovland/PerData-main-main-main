//
//  UpdatePersonsFromJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 08/11/2021.
//

import SwiftUI
import CloudKit

let jsonPersonFile = "PersonBackup.json"
private var message: LocalizedStringKey = ""

@MainActor
func updatePersonsFromJsonBackupFile() async -> LocalizedStringKey {
    
    var personElem : [PersonElem] = []
    var counter = 0
    
    var message: LocalizedStringKey = ""
    let modifyImage = false
    var person = Person()
    
    ///
    ///Leser inn fra Json til [PersonElem]
    ///
    if let url = Bundle.main.url(forResource: jsonPersonFile, withExtension: nil) {
        if let data = try? Data(contentsOf: url) {
            let jsondecoder = JSONDecoder()
            do{
                let result = try jsondecoder.decode([PersonElem].self, from: data)
                personElem = result
            }
            catch {
                message = "Error trying parse json"
                return message
            }
        }
    } else {
        message =  "Unknown json file"
        return message
    }
    
    ///
    ///Lagre person i Person tabellen
    ///
    for index in 0..<personElem.count {
        person = Person(
            firstName: personElem[index].personData.firstName,
            lastName: personElem[index].personData.lastName,
            personEmail: personElem[index].personData.personEmail,
            address: personElem[index].personData.address,
            phoneNumber: personElem[index].personData.phoneNumber,
            cityNumber: personElem[index].personData.cityNumber,
            city: personElem[index].personData.city,
            municipalityNumber: personElem[index].personData.municipalityNumber,
            municipality: personElem[index].personData.municipality,
            dateOfBirth:  convertStringToDate(dateIn: personElem[index].personData.dateOfBirth),
            dateMonthDay: personElem[index].personData.dateMonthDay,
            gender: personElem[index].personData.gender,
            image: nil)
        ///
        /// Sjekk om brukeren finnes
        ///
        var value : (LocalizedStringKey, Bool)
        value = await personExist(person)
        if value.0 != "" {
            ///
            ///Feilmelding
            ///
            message = value.0
            return message
        } else {
            if value.1 == true { // Personen finnes fra før
                /// Finn recordID for personen som finnes fra før
                var valueID: (LocalizedStringKey, CKRecord.ID?)
                await valueID = personRecordID(person)
                if valueID.0 != "" {
                    message = value.0
                    return message
                } else {
                    person.recordID = valueID.1
                    await message = modify(person, modifyImage)
                }
            } else { // Personen finnes ikke
                await message = save(person)
            }
            
            counter += 1
         }
    }
    
    message = LocalizedStringKey("Number of persons saved/modified from the Json backup file: \(counter)")
    return message
}

/// "29. 05 1977" -> 1977-05-29 00:00:00 +0000
/// Månedene må være på engelsk

/// Dato formateringer:
/// Wednesday, Feb 26, 2020                EEEE, MMM d, yyyy
/// 02/26/2020                                        MM/dd/yyyy
/// 02-26-2020 12:30                              MM-dd-yyyy HH:mm
/// Feb 26, 12:30 PM                              MMM d, h:mm a
/// February 2020                                   MMMM yyyy
/// Feb 26, 2020                                      MMM d, yyyy
/// Wed, 26 Feb 2020 12:30:24 +0000    E, d MMM yyyy HH:mm:ss Z
/// 2020-02-26T12:30:24+0000               yyyy-MM-dd'T'HH:mm:ssZ
/// 26.02.20                                             dd.MM.yy
/// 12:30:24.423                                      HH:mm:ss.SSS
func convertStringToDate(dateIn: String) -> Date {
    let formatter = DateFormatter()
    ///                     2005-12-14 00:00:00 +0000
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: dateIn)!
}
