//
//  Medal.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import Foundation
import SwiftData

@Model
class Medal {
  @Attribute(.unique)
  var id: String
  var name: String
  var detail: String
  var icon: String
  var category: String
  var rarity: String
  var backgroundColor: String
  var progressColor: String
  var level: Int
  var points: Int
  var maxLevel: Int
  var reward: String
  var unlockedAt: String
  var nextLevelGoal: String
  var isLocked: Bool
  var animationType: String

  init(
    id: String = UUID().uuidString,
    name: String,
    detail: String,
    icon: String,
    category: String,
    rarity: String,
    backgroundColor: String,
    progressColor: String,
    level: Int = 1,
    points: Int = 0,
    maxLevel: Int,
    reward: String,
    unlockedAt: String,
    nextLevelGoal: String,
    isLocked: Bool = false,
    animationType: String
  ) {
    self.id = id
    self.name = name
    self.detail = detail
    self.icon = icon
    self.category = category
    self.rarity = rarity
    self.backgroundColor = backgroundColor
    self.progressColor = progressColor
    self.level = level
    self.points = points
    self.maxLevel = maxLevel
    self.reward = reward
    self.unlockedAt = unlockedAt
    self.nextLevelGoal = nextLevelGoal
    self.isLocked = isLocked
    self.animationType = animationType
  }
}
