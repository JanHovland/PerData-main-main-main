//
//  PersonDetailMapView.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

///
///https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html#//apple_ref/doc/uid/TP40007899-CH5-SW1
///

import SwiftUI

struct PersonDetailMapView: View {
    var person: Person
    var body: some View {
        Image("map")
            .resizable()
            .frame(width: 36, height: 36, alignment: .center)
            .gesture(
                TapGesture()
                    .onEnded({_ in
                         mapAddress(address: person.address,
                                   cityNumber: person.cityNumber,
                                   city: person.city)
                    })
            )
    }
}

///
/// Oversett address og city som inneholder æøå og ÆØÅ
///

func mapAddress (address: String,
                 cityNumber: String,
                 city: String) {
    
    let m1 = address.replacingOccurrences(of: "å", with: "aa")
    let m2 = m1.replacingOccurrences(of: "Å", with: "AA")
    let m3 = m2.replacingOccurrences(of: "ø", with: "oe")
    let m4 = m3.replacingOccurrences(of: "Ø", with: "OE")
    let m5 = m4.replacingOccurrences(of: "æ", with: "ae")
    let m6 = m5.replacingOccurrences(of: "Æ", with: "AE")
    
    let n1 = city.replacingOccurrences(of: "å", with: "aa")
    let n2 = n1.replacingOccurrences(of: "Å", with: "AA")
    let n3 = n2.replacingOccurrences(of: "ø", with: "oe")
    let n4 = n3.replacingOccurrences(of: "Ø", with: "OE")
    let n5 = n4.replacingOccurrences(of: "æ", with: "ae")
    let n6 = n5.replacingOccurrences(of: "Æ", with: "AE")
    
    let address = m6
    let city = n6
    let b = "http://maps.apple.com/?address=" + address + " "
        + cityNumber + " "
        + city + " " + "&t=s"
    let a = b.replacingOccurrences(of: " ", with: ",")
    UIApplication.shared.open(URL(string: a)!)
}
