//
//  UpdateZipCodesFromCSV.swift
//  PerData
//
//  Created by Jan Hovland on 03/11/2021.
//

import SwiftUI

@MainActor
func updatePostNummerFromCSV() async -> LocalizedStringKey {
    
    let index = 0
//
//    /// Finner URL fra prosjektet
//    guard let contentsOfURL = Bundle.main.url(forResource: "Postnummerregister-ansi", withExtension: "txt") else { return "Zip file is missing!" }
//    /// Må bruke encoding == ascii (utf8 virker ikke)
//    let zipCodes = ParseCSV (contentsOfURL: contentsOfURL,
//                              delimiter: "    ")
//    let maxNumber =  zipCodes!.count
//    repeat {
//        let zipCode = zipCodes![index]
//        await _ = saveZipCode(zipCode)
//        index += 1
//        print(index)
//    } while index < maxNumber
    let message = LocalizedStringKey("Number of ZipCode saved: \(index)")
    return message
}
