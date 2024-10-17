//
//  CloudCabinHelper.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI
import CloudKit

///
/// Ved å endre f. eks. func save(person: Person)  til:
///     func save(_ person: Person)  kan den kalles slik:
///     save(person) i stedet for save(person: person)
///

@MainActor
func saveCabin(_ cabin: Cabin) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitCabin().saveCabin(cabin)
        message = "The cabin has been saved in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

@MainActor
func modifyCabin(_ cabin: Cabin) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitCabin().modifyCabin(cabin)
        message = "The cabin has been modified in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

@MainActor
func cabinExist(_ predicate: NSPredicate, _ cabin: Cabin) async -> (err: LocalizedStringKey, exist: Bool) {
    var err : LocalizedStringKey = ""
    var exist : Bool = false
    do {
        exist = try await CloudKitCabin().existCabin(predicate, cabin)
        err = ""
    } catch {
        print(error.localizedDescription)
        err  = LocalizedStringKey(error.localizedDescription)
        exist = false
    }
    return (err, exist)
}

func findCabins() async -> (err: LocalizedStringKey, cabins: [Cabin]) {
    var err : LocalizedStringKey = ""
    var cabins = [Cabin]()
    do {
        err = ""
        cabins = try await CloudKitCabin().getAllCabins()
    } catch {
        err  = LocalizedStringKey(error.localizedDescription)
        cabins = [Cabin]()
    }
    
    return (err , cabins)
}

@MainActor
func deleteCabin(_ recID: CKRecord.ID) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitCabin().deleteOneCabin(recID)
        message = "The cabin has been deleted"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

@MainActor
func cabinRecordID(_ predicate: NSPredicate, _ cabin: Cabin) async -> (err: LocalizedStringKey, id: CKRecord.ID?) {
    var err : LocalizedStringKey = ""
    var id: CKRecord.ID?
    do {
        id = try await CloudKitCabin().getCabinRecordID(predicate,cabin)
        err = ""
    } catch {
        print(error.localizedDescription)
        err = LocalizedStringKey(error.localizedDescription)
        id = nil
    }
    return (err, id)
}
    
func deleteAllCabins(_ predicate: NSPredicate,_ recID: CKRecord.ID) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitCabin().deleteAllCabins(predicate, recID)
        message = "All cabins have been deleted"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}
