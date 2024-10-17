//
//  HudView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

///
/// Bruk:          HudView(textMessage: "textMessage",   backGroundColor: Color.green)
///

struct HudView: View {
    var hudMessage: String
    var backGroundColor: Color
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showHUD = false
    var body: some View {
        Hud(content: showHUD ? Text(hudMessage) : Text(""))
            .background(showHUD ? backGroundColor : Color.clear)
            .cornerRadius(15)
            .onAppear() {
                self.showHUD = true
                dismissHUD()
            }
    }
    
    func dismissHUD() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showHUD = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}
 
