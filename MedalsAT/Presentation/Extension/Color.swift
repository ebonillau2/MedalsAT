//
//  Color.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI

extension Color {
  init(hex: String) {
    // Limpia el string de espacios y #
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexString = hexString.replacingOccurrences(of: "#", with: "")

    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)

    let red, green, blue: Double

    switch hexString.count {
    case 6: // RGB
      red = Double((rgbValue & 0xFF0000) >> 16) / 255
      green = Double((rgbValue & 0x00FF00) >> 8) / 255
      blue = Double(rgbValue & 0x0000FF) / 255
    default:
      red = 0
      green = 0
      blue = 0
    }

    self.init(red: red, green: green, blue: blue)
  }
}
