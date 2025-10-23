//
//  MedalsPersistace.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import Foundation
import SwiftData

protocol MedalsPersistace: Sendable {
  func fetchMedals(context: ModelContext) -> [Medal]
  func removeAllMedals(context: ModelContext)
}
