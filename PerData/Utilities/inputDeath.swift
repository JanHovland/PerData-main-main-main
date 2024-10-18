//
//  inputDeath.swift
//  PerData
//
//  Created by Jan Hovland on 18/10/2024.
//

import SwiftUI

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
