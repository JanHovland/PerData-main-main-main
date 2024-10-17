//
//  ViewModifiers.swift
//  PerData
//
//  Created by Jan Hovland on 02/11/2021.
//

import SwiftUI

///
/// https://useyourloaf.com/blog/swiftui-custom-view-modifiers/
///

struct BackToCaller: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    var value : LocalizedStringKey = ""
    func body(content: Content) -> some View {
        content
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
            })
    }
}

extension View {
    func backToCaller(_ value: LocalizedStringKey) -> some View {
        modifier(BackToCaller(value: value))
    }
}
