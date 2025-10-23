//
//  ToastView.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI

struct ToastView: View {
  var message: String
  
  var body: some View {
    Text(message)
      .font(.subheadline)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(.ultraThinMaterial)
      .cornerRadius(12)
      .shadow(radius: 5)
      .transition(.move(edge: .top).combined(with: .opacity))
      .padding(.top, 40)
  }
}

#Preview {
  ToastView(message: "Hello, World!")
}