//
//  Hud.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import SwiftUI

struct Hud<Content: View>: View {
    var content: Content
    @ViewBuilder var body: some View {
        content
            .padding(.horizontal, 10)
            .padding(10)
        
            .frame(width: 200, height: 100, alignment: .center)
    }
}
