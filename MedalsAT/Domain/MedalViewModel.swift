//
//  MedalViewModel.swift
//  Medals_AT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import Foundation
import SwiftData
import Combine
import UIKit

@MainActor
final class MedalViewModel: ObservableObject {
  @Published var medals: [Medal]
  
  var modelContext: ModelContext
  var persistace: MedalsPersistace
  private var updateTask: Task<Void, Never>? = nil
  private var tapCount = 0
  
  init(modelContext: ModelContext, persistace: MedalsPersistace = MedalsPersistaceImp()) {
    self.modelContext = modelContext
    self.persistace = persistace
    medals = persistace.fetchMedals(context: modelContext)
    observeAppLifecycle()
    startUpdatingMedals()
  }
  
  private func observeAppLifecycle() {
    // Call when scene is about to move from the active state to the inactive state
    NotificationCenter.default.addObserver(
      forName: UIScene.willDeactivateNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.stopUpdatingMedals()
      }
    }
    
    // Call when scene becomes active again
    NotificationCenter.default.addObserver(
      forName: UIScene.didActivateNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.startUpdatingMedals()
      }
    }
  }
  
  private func startUpdatingMedals() {
    guard updateTask == nil else { return }
    
    updateTask = Task {
      while !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))
        
        await MainActor.run {
          for medal in medals {
            guard medal.level < medal.maxLevel else { continue }
            
            let randomIncrement = Int.random(in: 0...25)
            medal.points += randomIncrement
            
            if medal.points >= 100 {
              medal.points = 0
              medal.level += 1
              if medal.level > medal.maxLevel {
                medal.level = medal.maxLevel
              }
              try? modelContext.save()
              
              NotificationCenter.default.post(
                name: .medalLeveledUp,
                object: medal.id
              )
            }
          }
          do {
            try modelContext.save()
          } catch {
            print("Error Saving Model \(error.localizedDescription)")
          }
        }
      }
    }
  }
  
  func resetDataIfNeeded() {
    tapCount += 1
    if tapCount == 5 {
      persistace.removeAllMedals(context: modelContext)
      medals = persistace.fetchMedals(context: modelContext)
      tapCount = 0
    }
  }
  
  private func stopUpdatingMedals() {
    updateTask?.cancel()
    updateTask = nil
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension Notification.Name {
  static let medalLeveledUp = Notification.Name("medalLeveledUp")
}
