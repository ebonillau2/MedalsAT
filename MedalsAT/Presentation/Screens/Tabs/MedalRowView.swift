//
//  MedalRowView.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import UIKit

struct MedalRowView: View {
  var medal: Medal
  @State private var showConfetti = false

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(medal.name)
          .font(.headline)
          .foregroundStyle(Color(hex: medal.progressColor))
        HStack {
          Text("LVL \(medal.level)")
            .foregroundStyle(Color.black)
          CustomAnimatedProgressView(value: Double(medal.points),
                                     total: 100,
                                     color: Color(hex: medal.progressColor),
                                     height: CGFloat(20))
        }
        .frame(height: 20)
      }
      Spacer()
      Text("\(medal.points)/100")
        .font(.caption)
        .foregroundStyle(Color.black)
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 12)
      .fill(Color(hex: medal.backgroundColor)))
    .overlay(
      ZStack {
        if showConfetti {
          ConfettiView()
            .transition(.scale)
        }
      }
    )
    .onReceive(NotificationCenter.default.publisher(for: .medalLeveledUp)) { notif in
      if notif.object as? String == medal.id {
        withAnimation(.spring()) {
          showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            showConfetti = false
          }
        }
      }
    }
  }
}

struct CustomAnimatedProgressView: View {
  let value: Double
  let total: Double
  let color: Color
  let height: CGFloat

  private var progress: Double {
    value / total
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        // Background
        Rectangle()
          .foregroundColor(color.opacity(0.3))
          .frame(height: height)

        // Progress fill with animation
        Rectangle()
          .foregroundColor(color)
          .frame(width: geometry.size.width * progress, height: height)
          .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
      }
      .cornerRadius(height / 2)
    }
    .frame(height: height)
  }
}

#Preview {
  // swiftlint:disable:next line_length
  MedalRowView(medal: Medal(name: "Hábito Constante", detail: "Inicia sesión 7 días seguidos", icon: "medal3.png", category: "Rutina", rarity: "Common", backgroundColor: "#E6FFE6", progressColor: "#4CAF50", maxLevel: 10, reward: "20 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 50 puntos", animationType: "sparkle"))
}
