//
//  PersonEdit.swift
//  PerData
//
//  Created by Jan Hovland on 28/10/2021.
//

import SwiftUI

struct PersonEditView: View {
    
    @State var person: Person
    
    var body: some View {
        TextField("FirstName", text: $person.firstName)
            .textFieldStyle(.roundedBorder)
        TextField("LastName", text: $person.lastName)
            .textFieldStyle(.roundedBorder)
    }
}

