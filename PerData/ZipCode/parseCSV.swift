//
//  parseCSV.swift
//  PerData
//
//  Created by Jan Hovland on 03/11/2021.
//

import Foundation

func ParseCSV (contentsOfURL: URL,
               delimiter: String) -> [(ZipCode)]? {
    
    /// Finne det rette formatet på Postnummerregister-ansi.txt filen:
    /// Gå til https://www.bring.no/tjenester/adressetjenester/postnummer
    ///
    /// Hent: Tab-separerte felter (ANSI)
    /// Kopier direkte fra det som vises på skjermen
    /// Erstatt disse tegnene med:
    ///  ∆ mrd  Æ
    ///  ÿ med  Ø
    ///  ≈ med  Å
    ///  ¡ med   O    9716    BÿRSELV    5436    PORSANGER PORS¡NGU PORSANKI    G
    ///  Ferdig!
    
    var zipCode: ZipCode! = ZipCode()
    var zipCodes: [(ZipCode)]?
    
    do {
        let content = try String(contentsOf: contentsOfURL, encoding: .ascii)
        
        zipCodes = []
        let lines: [String] = content.components(separatedBy: .newlines)
        for line in lines {
            var values:[String] = []
            if line != "" {
                values = line.components(separatedBy: delimiter)
                zipCode.postalNumber = values[0]
                zipCode.postalName = values[1]
                zipCode.municipalityNumber = values[2]
                zipCode.municipalityName = values[3]
                zipCode.category = values[4]
                zipCodes?.append(zipCode)
            }
        }
    } catch {
        let _ = error.localizedDescription
    }
    return zipCodes
}
