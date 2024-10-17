//
//  MakeAttributedString.swift
//  PerData
//
//  Created by Jan Hovland on 13/11/2021.
//


import SwiftUI

/// https://betterprogramming.pub/ios-15-attributed-strings-in-swiftui-markdown-271204bec5c1

/*

 A general approach for using standard font size options and weights that work with SwiftUI TextField. For example:
 
 TextField("Name", text: $name)
 .font(Font.headline.weight(.light))
 Available standard size options (smallest to largest):
 
 .caption
 .footnote
 .subheadline
 .callout
 .body
 .headline
 .title3
 .title2
 .title
 .largeTitle
 Available standard font weights (lightest to heaviest):
 
 .ultraLight
 .thin
 .light
 .regular
 .medium
 .semibold
 .bold
 .heavy
 .black
 
 .font(Font.headline.weight(.ultraLight))
 
 
 */

func makeAttributedString(text1: String,
                          text2: String,
                          color1: Color,
                          color2: Color,
                          font1: Font,
                          font2: Font) -> AttributedString {
    var string = AttributedString(text1)
    string.foregroundColor = color1
    string.font = font1
    
    if let range = string.range(of: text2) {
        string[range].foregroundColor = color2
        string[range].font = font2
    }
    
    return string
}

