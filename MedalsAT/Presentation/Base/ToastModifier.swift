//
//  ToastModifier.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let message: String
  let duration: TimeInterval
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      if isPresented {
        VStack {
          ToastView(message: message)
          Spacer()
        }
        .zIndex(1)
      }
    }
    .animation(.spring(), value: isPresented)
  }
}

extension View {
  func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
    self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
  }
}
