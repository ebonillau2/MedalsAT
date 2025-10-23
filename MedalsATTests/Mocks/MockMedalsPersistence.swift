//
//  MockMedalsPersistace.swift
//  MedalsATTests
//
//  Created by Enrique Bonilla on 23/10/25.
//

import Foundation
import SwiftData
@testable import MedalsAT

struct MockMedalsPersistence: MedalsPersistence {
  
  // Change to te maxLevel to test
  let maxLevel: Int = 5
  
  /// Load medals only once if them doesn't exist
  func fetchMedals(context: ModelContext) -> [Medal] {
    return createInitialData()
  }

  func createInitialData(withLvl: Int = 1, points: Int = 0) -> [Medal] {
    // swiftlint:disable line_length
    let initialMedals = [
      Medal(name: "Apostador Novato", detail: "Alcanza tus primeros 100 puntos", icon: "medal1.png", category: "Progreso", rarity: "Common", backgroundColor: "#E6F4FF", progressColor: "#2196F3", level: withLvl, points: points, maxLevel: maxLevel, reward: "10 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 55 puntos para nivel 2", animationType: "sparkle"),
      Medal(name: "Inversionista Experto", detail: "Gana tus primeras 1000 monedas", icon: "medal2.png", category: "Progreso", rarity: "Rare", backgroundColor: "#FFF4E6", progressColor: "#FF9800", level: withLvl, points: points, maxLevel: maxLevel, reward: "50 monedas", unlockedAt: "Nivel 2 completado", nextLevelGoal: "Suma 200 puntos", animationType: "shine"),
      Medal(name: "Hábito Constante", detail: "Inicia sesión 7 días seguidos", icon: "medal3.png", category: "Rutina", rarity: "Common", backgroundColor: "#E6FFE6", progressColor: "#4CAF50", level: withLvl, points: points, maxLevel: maxLevel, reward: "20 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 50 puntos", animationType: "sparkle")
    ]
    return initialMedals
  }

  func removeAllMedals(context: ModelContext) {
    // Mocking
  }
}
