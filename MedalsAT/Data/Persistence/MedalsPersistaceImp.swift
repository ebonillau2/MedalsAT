//
//  MockMedalsService.swift
//  Medals_AT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import Foundation
import SwiftData

struct MedalsPersistaceImp: MedalsPersistace {

  /// Load medals only once if them doesn't exist
  func fetchMedals(context: ModelContext) -> [Medal] {
    let descriptor = FetchDescriptor<Medal>()
    if let existingMedals = try? context.fetch(descriptor), existingMedals.isEmpty == false {
      print("📦 Medals load from SwiftData")
      return existingMedals
    } else {
      return createInitialData(context: context)
    }
  }
  
  private func createInitialData(context: ModelContext) -> [Medal] {
    let initialMedals = [
      Medal(name: "Apostador Novato", detail: "Alcanza tus primeros 100 puntos", icon: "medal1.png", category: "Progreso", rarity: "Common", backgroundColor: "#E6F4FF", progressColor: "#2196F3", maxLevel: 10, reward: "10 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 55 puntos para nivel 2", animationType: "sparkle"),
      Medal(name: "Inversionista Experto", detail: "Gana tus primeras 1000 monedas", icon: "medal2.png", category: "Progreso", rarity: "Rare", backgroundColor: "#FFF4E6", progressColor: "#FF9800", maxLevel: 10, reward: "50 monedas", unlockedAt: "Nivel 2 completado", nextLevelGoal: "Suma 200 puntos", animationType: "shine"),
      Medal(name: "Hábito Constante", detail: "Inicia sesión 7 días seguidos", icon: "medal3.png", category: "Rutina", rarity: "Common", backgroundColor: "#E6FFE6", progressColor: "#4CAF50", maxLevel: 10, reward: "20 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 50 puntos", animationType: "sparkle"),
      Medal(name: "Maestro de Estrategia", detail: "Completa 5 misiones exitosas", icon: "medal4.png", category: "Misiones", rarity: "Epic", backgroundColor: "#FFE6E6", progressColor: "#F44336", maxLevel: 10, reward: "100 monedas", unlockedAt: "Misiones iniciadas", nextLevelGoal: "Suma 80 puntos", animationType: "burst"),
      Medal(name: "Racha de Oro", detail: "Mantén una racha de 10 victorias", icon: "medal5.png", category: "Rachas", rarity: "Rare", backgroundColor: "#FFF4E6", progressColor: "#FFC107", maxLevel: 10, reward: "50 monedas", unlockedAt: "Racha iniciada", nextLevelGoal: "Suma 70 puntos", animationType: "sparkle"),
      Medal(name: "Coleccionista", detail: "Sube 5 medallas al nivel máximo", icon: "medal6.png", category: "Colección", rarity: "Epic", backgroundColor: "#E6E6FF", progressColor: "#3F51B5", maxLevel: 10, reward: "150 monedas", unlockedAt: "Medallas desbloqueadas", nextLevelGoal: "Suma 90 puntos", animationType: "confetti"),
      Medal(name: "Aventurero", detail: "Explora 3 nuevas modalidades", icon: "medal7.png", category: "Progreso", rarity: "Common", backgroundColor: "#E6FFF4", progressColor: "#00BCD4", maxLevel: 10, reward: "20 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 60 puntos", animationType: "sparkle"),
      Medal(name: "Competitivo", detail: "Gana tu primer torneo", icon: "medal8.png", category: "Competición", rarity: "Rare", backgroundColor: "#FFF4E6", progressColor: "#FF5722", maxLevel: 10, reward: "50 monedas", unlockedAt: "Torneo completado", nextLevelGoal: "Suma 80 puntos", animationType: "shine"),
      Medal(name: "Maestro del Tiempo", detail: "Completa una misión en menos de 5 min", icon: "medal9.png", category: "Misiones", rarity: "Epic", backgroundColor: "#E6FFE6", progressColor: "#4CAF50", maxLevel: 10, reward: "100 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 100 puntos", animationType: "sparkle"),
      Medal(name: "Leyenda", detail: "Alcanza el nivel máximo en todas las medallas", icon: "medal10.png", category: "Progreso", rarity: "Legendary", backgroundColor: "#FFE6E6", progressColor: "#E91E63", maxLevel: 10, reward: "500 monedas", unlockedAt: "Registro completado", nextLevelGoal: "Suma 100 puntos", animationType: "confetti")
    ]
    for medal in initialMedals {
      context.insert(medal)
    }
    do {
      // 💾 Save in persistence
      try context.save()
      print("✅ Initial data created")
    } catch  {
      print("✅ Failed to save data")
    }
    return initialMedals
  }
  
  func removeAllMedals(context: ModelContext) {
    do {
      let fetchDescriptor = FetchDescriptor<Medal>()
      let allMedals = try context.fetch(fetchDescriptor)
      
      for medal in allMedals {
        context.delete(medal)
      }
      
      try context.save()
      print("✅ All medals removed satisfactory.")
    } catch {
      print("❌ Error removing medals: \(error.localizedDescription)")
    }
  }
}

