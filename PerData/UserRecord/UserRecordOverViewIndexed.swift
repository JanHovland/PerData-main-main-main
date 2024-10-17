//
//  UserRecordOverViewIndexed.swift
//  PerData
//
//  Created by Jan Hovland on 29/11/2021.
//

import SwiftUI
import CloudKit

struct userRecordOverViewIndexed: View {
    
    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var indicatorShowing = false
    @State private var isAlertActive = false
    
    @State private var message: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var searchText = ""
    
    @State private var indexSetDelete = IndexSet()
    @State private var recordID: CKRecord.ID?
    @State private var userRecords = [UserRecord]()
    
    @State private var sectionHeader = [String]()
    
    @State private var predicate = NSPredicate(value: true)
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ActivityIndicator(isAnimating: $indicatorShowing, style: .medium, color: .gray)
                ScrollView {
                    VStack (alignment: .leading) {
                        ForEach(sectionHeader, id: \.self) { letter in
                            
                            Section(header: SectionHeader(letter: letter)) {
                                ForEach(userRecords.filter( {
                                    (userRecord) -> Bool in
                                    userRecord.firstName.prefix(1) == letter
                                })) {
                                    userRecord in
                                    
                                    if searchText == "" || userRecord.firstName.uppercased().contains(searchText.uppercased()) {
                                        NavigationLink(destination: UserRecordDetailView(userRecord: userRecord)) {
                                            showUsers(userRecord: userRecord)
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                }
                                .onDelete { (indexSet) in
                                    indexSetDelete = indexSet
                                    recordID = userRecords[indexSet.first!].recordID
                                    userRecords.removeAll()
                                    Task.init {
                                        await message = deleteUserRecord(recordID!)
                                        title = "Delete UserRecord"
                                        isAlertActive.toggle()
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    /// Fjerner ekstra tomt felt med tilhørede linje
                    .listStyle(InsetListStyle())
                    .listRowSeparator(.hidden)
                    .alert(title, isPresented: $isAlertActive) {
                        Button("OK", action: {})
                    } message: {
                        Text(message)
                    }
                    .navigationBarTitle("User OverView", displayMode: .inline)
                    .task {
                        if userRecords.count == 0 {
                            indicatorShowing = true
                            await refreshUsersIndexed()
                            indicatorShowing = false
                        }
                    }
                    
                    .refreshable {
                        await refreshUsersIndexed()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            ControlGroup {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    ReturnFromMenuView(text: "PersonOverView")
                                }
                            }
                            .controlGroupStyle(.navigation)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ControlGroup {
                                Button {
                                    Task.init {
                                        indicatorShowing = true
                                        await refreshUsersIndexed()
                                        indicatorShowing = false
                                    }
                                } label: {
                                    Text("Refresh")
                                }
                            }
                            .controlGroupStyle(.navigation)
                        }
                    })
                } // ScrollViewReader
//                .overlay(sectionIndexTitles(proxy: proxy,
//                                            titles: sectionHeader))
            }
        } // NavigationView
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search firstName")
        .onChange(of: searchText.capitalized) { searchText, oldSearchText in
            predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "firstName BEGINSWITH %@", searchText)
            Task.init {
                indicatorShowing = true
                await refreshUsersIndexed()
                indicatorShowing = false
            }
        }
    }
    
    func refreshUsersIndexed() async {
        /// Sletter alt tidligere innhold i userRecord
        userRecords.removeAll()
        sectionHeader.removeAll()
        /// Fetch all userRecords  from CloudKit
        var value: (LocalizedStringKey, [UserRecord], [String])
        await value = findUserRecords()
        if value.0 != "" {
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            userRecords = value.1
            sectionHeader = value.2
        }
    }
    
    struct showUsers: View {
        var userRecord: UserRecord
        
        var body: some View {
            HStack  {
                if userRecord.image != nil {
                    Image(uiImage: userRecord.image!)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .font(.system(size: 16, weight: .ultraLight))
                        .frame(width: 30, height: 30, alignment: .center)
                }
                VStack (alignment: .leading){
                    Text(userRecord.firstName + " " + userRecord.lastName)
                    Text(userRecord.email)
                }
                .font(Font.body.weight(.regular))
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.leading, 10)

        }
    }
    
}

