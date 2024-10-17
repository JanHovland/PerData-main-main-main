//
//  CloudUserHelper.swift
//  PerData
//
//  Created by Jan Hovland on 16/11/2021.
//

import SwiftUI
import CloudKit

@MainActor
func saveUserRecord(_ userRecord: UserRecord) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitUserRecord().saveUserRecord(userRecord)
        message = "The userRecord has been saved in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

@MainActor
func modifyUserRecord(_ userRecord: UserRecord, _ newImage: Bool) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitUserRecord().modifyUserRecord(userRecord, newImage)
        message = "The user has been modified in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func userRecordExist(_ userRecord: UserRecord) async -> (err: LocalizedStringKey, exist: Bool) {
    var err : LocalizedStringKey = ""
    var exist : Bool = false
    var value: (Bool, Any?)
    do {
        try await value = CloudKitUserRecord().existUserRecord(userRecord)
        exist = value.0
    } catch {
        print(error.localizedDescription)
        err  = LocalizedStringKey(error.localizedDescription)
        exist = false
    }
    return (err, exist)
}

func findUserRecords() async -> (err: LocalizedStringKey,
                                                          userRecords: [UserRecord],
                                                          sectionHeader: [String]) {
    var err : LocalizedStringKey = ""
    var userRecords = [UserRecord]()
    var sectionHeader = [String]()
    let predicate = NSPredicate(value: true)
    do {
        err = ""
        (userRecords, sectionHeader) = try await CloudKitUserRecord().getAllUserRecords(predicate)
    } catch {
        err  = LocalizedStringKey(error.localizedDescription)
        userRecords = [UserRecord]()
    }
    return (err , userRecords, sectionHeader)
}

@MainActor
func deleteUserRecord(_ recID: CKRecord.ID) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitUserRecord().deleteOneUserRecord(recID)
        message = "The user has been deleted"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func userRecordRecordID(_ userRecord: UserRecord) async -> (err: LocalizedStringKey, id: CKRecord.ID?) {
    var err : LocalizedStringKey = ""
    var id: CKRecord.ID?
    do {
        id = try await CloudKitUserRecord().getUserRecordRecordID(userRecord)
        err = ""
    } catch {
        print(error.localizedDescription)
        err = LocalizedStringKey(error.localizedDescription)
        id = nil
    }
    return (err, id)
}
    
func findUserRecord(userRecord:  UserRecord) async -> (err: LocalizedStringKey, userRecords: UserRecord) {
    var err : LocalizedStringKey = ""
    let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@", userRecord.firstName, userRecord.lastName)
    
    var userRecords = UserRecord(firstName: "",
                                 lastName: "",
                                 email: "",
                                 passWord: "",
                                 image: nil)
    do {
        err = ""
        userRecords = try await CloudKitUserRecord().getUserRecord(predicate)
    } catch {
        err  = LocalizedStringKey(error.localizedDescription)
        userRecords = UserRecord(firstName: "",
                                 lastName: "",
                                 email: "",
                                 passWord: "",
                                 image: nil)
    }
    return (err , userRecords)
}

