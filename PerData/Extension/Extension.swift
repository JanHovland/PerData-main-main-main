//
//  Extension.swift
//  PerData
//
//  Created by Jan Hovland on 14/10/2024.
//

import SwiftUI

extension UIDevice {
  
  static var idiom: UIUserInterfaceIdiom {
    UIDevice.current.userInterfaceIdiom
  }
  
  static var isIpad: Bool {
    idiom == .pad
  }
  
  static var isiPhone: Bool {
    idiom == .phone
  }
}
