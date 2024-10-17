//
//  CabinOverview.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI
import CloudKit

var selectedRecordId: CKRecord.ID?

struct cabinOverView: View {
   
    @Environment(\.presentationMode) var presentationMode
    
    @State private var cabins = [Cabin]()
    @State private var indexSetDelete = IndexSet()
    @State private var message: LocalizedStringKey = ""
    @State private var hudMessage: LocalizedStringKey = ""
    @State private var title: LocalizedStringKey = ""
    @State private var choise: LocalizedStringKey = ""
    @State private var indicatorShowing = false
    @State private var isAlertActive = false
    @State private var recordID: CKRecord.ID?
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cabins) {
                        cabin in
                        HStack {
                            VStack {
                                Text(cabin.firstName)
                                Text(cabin.lastName)
                            }
                            .font(Font.title3.weight(.ultraLight))
                            HStack {
                                Spacer()
                                Text(String(IntToDateString(int: cabin.fromDate)))
                                Text(String(IntToDateString(int: cabin.toDate)))
                            }
                            .font(Font.footnote.weight(.regular))
                            .background(Color("Background"))
                            .cornerRadius(5)
                            .padding(.horizontal, 5)
                        }
                    }
                    /// onDelete finnes bare i iOS
                    .onDelete { (indexSet) in
                        indexSetDelete = indexSet
                        recordID = cabins[indexSet.first!].recordID
                        cabins.removeAll()
                        Task.init {
                            await message = deleteCabin(recordID!)
                            title = "Delete a cabin"
                            isAlertActive.toggle()
                            ///
                            /// Viser resten av hytte reservasjonene
                            ///
                            await refreshCabins()
                        }
                    }
                    .refreshable {
                        await refreshCabins()
                    }
                }
            }
            .navigationBarTitle("Cabin OverView", displayMode: .inline)
            .task {
                await refreshCabins()
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
                    Button(action: {
                        /// Rutine for å friske opp bruker oversikten
                        Task.init {
                            await refreshCabins()
                        }
                    }, label: {
                        Text("Refresh")
                            .font(Font.headline.weight(.light))
                    })
                }
            })
        }
    }
    
    /// Rutine for å friske opp bildet
    func refreshCabins() async {
        /// Sletter alt tidligere innhold i hytte
        cabins.removeAll()
        indicatorShowing = true
        let predicate = NSPredicate(value: true)
        await FindAllCabins(predicate)
        indicatorShowing = false
    }
    
    func FindAllCabins(_ predicate: NSPredicate) async {
        var value: (LocalizedStringKey, [Cabin])
        await value = findCabins()
        if value.0 != "" {
            message = value.0
            title = "Error message from the Server"
            isAlertActive.toggle()
        } else {
            cabins = value.1
        }
    }
    
}

func IntToDateString (int: Int) -> String {
    if int > 0 {
        let str = String(int)
        let index3 = str.index(str.startIndex, offsetBy: 3)
        let index4 = str.index(str.startIndex, offsetBy: 4)
        let index5 = str.index(str.startIndex, offsetBy: 5)
        let index6 = str.index(str.startIndex, offsetBy: 6)
        let month = Int(str[index4...index5]) ?? 0
        let monthName : [String] = ["jan",
                                    "feb",
                                    "mar",
                                    "apr",
                                    "may",
                                    "jun",
                                    "jul",
                                    "aug",
                                    "sep",
                                    "oct",
                                    "nov",
                                    "dec"]
        return str[index6...]  + ". " + monthName[month - 1] + " " + str[...index3]
    } else {
        return "0"
    }
}
