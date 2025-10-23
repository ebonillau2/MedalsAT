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

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(medal.name)
          .font(.headline)
          .foregroundStyle(Color(hex: medal.progressColor))
        HStack {
          Text("LVL \(medal.level)")
          ProgressView(value: Float(medal.points),
                       total: 100)
            .progressViewStyle(BarProgressStyle(color:Color(hex: medal.progressColor),
                                                height: 20.0))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .frame(height: 20)
      }
      Spacer()
      Text("\(medal.points)/100")
        .font(.caption)
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 12)
      .fill(Color(hex: medal.backgroundColor)))
  }
}

#Preview {
  MedalRowView(medal: Medal(name: "Hábito Constante", detail: "Inicia sesión 7 días seguidos", icon: "medal3.png", category: "Rutina", rarity: "Common", backgroundColor: "#E6FFE6", progressColor: "#4CAF50", maxLevel: 10, reward: "20 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 50 puntos", animationType: "sparkle"))
}
