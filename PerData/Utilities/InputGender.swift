//
//  InputGender.swift
//  PerData
//
//  Created by Jan Hovland on 01/11/2021.
//

import SwiftUI

struct InputGender: View {
    var heading: String
    var genders: [String]
    @Binding var value: Int
    
    var body: some View {
        VStack {
            HStack (alignment: .center, spacing: 90) {
                Text(heading)
                Picker(selection: $value, label: Text("")) {
                    ForEach(0..<genders.count, id: \.self) { index in
                        Text(genders[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding(.leading, 10)
    }
}

struct InputDeath: View {
    var heading: String
    var death: [String]
    @Binding var value: Int
    
    var body: some View {
        VStack {
            HStack (alignment: .center, spacing: 90) {
                Text(heading)
                Picker(selection: $value, label: Text("")) {
                    ForEach(0..<death.count, id: \.self) { index in
                        Text(death[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}
