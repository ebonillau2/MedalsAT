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
  @Published var medals: [Medal] = []
  @Published var showToast: Bool = false

  var modelContext: ModelContext
  var persistence: MedalsPersistence
  private var updateTask: Task<Void, Never>?
  private(set) var tapCount = 0
  private(set) var maxIncrementPoints = 20

  // Keep observer tokens so we can remove them correctly
  private var lifecycleObservers: [NSObjectProtocol] = []

  init(modelContext: ModelContext,
       persistence: MedalsPersistence? = nil) {
    self.modelContext = modelContext
    // Initialize the persistence implementation on the MainActor to avoid
    // calling an actor-isolated initializer from a non-isolated default arg.
    self.persistence = persistence ?? MedalsPersistenceImp()
  }

  func startObservingChanges() {
    if medals.isEmpty {
      medals = persistence.fetchMedals(context: modelContext)
    }
    observeAppLifecycle()
    startUpdatingMedals()
  }

  private func observeAppLifecycle() {
    // prevent adding duplicate observers
    guard lifecycleObservers.isEmpty else { return }

    // Call when scene is about to move to the inactive state
    let willDeactivate = NotificationCenter.default.addObserver(
      forName: UIScene.willDeactivateNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.stopUpdatingMedals()
        print("willDeactivateNotification")
      }
    }

    // Call when scene becomes active again
    let didActivate = NotificationCenter.default.addObserver(
      forName: UIScene.didActivateNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor [weak self] in
        self?.startUpdatingMedals()
        print("didActivateNotification")
      }
    }

    lifecycleObservers.append(contentsOf: [willDeactivate, didActivate])
  }

  private func startUpdatingMedals() {
    guard updateTask == nil else { return }

    // Run the loop as a Task on the MainActor.
    updateTask = Task { [weak self] in
      while !Task.isCancelled {
        try? await Task.sleep(for: .seconds(1))

        guard let self = self else { break }

        for medal in self.medals {
          guard medal.level < medal.maxLevel else { continue }

          let randomIncrement = Int.random(in: 0...maxIncrementPoints)
          medal.points += randomIncrement

          if medal.points >= 100 {
            medal.points = 0
            medal.level += 1
            if medal.level > medal.maxLevel {
              medal.level = medal.maxLevel
            }
            try? self.modelContext.save()

            NotificationCenter.default.post(
              name: .medalLeveledUp,
              object: medal.id
            )
          }
        }
        do {
          try self.modelContext.save()
        } catch {
          print("Error Saving Model \(error.localizedDescription)")
        }
      }
    }
  }

  func resetDataIfNeeded() {
    showToast = true
    Task {
      try? await Task.sleep(for: .seconds(1))
      showToast = false
    }
    tapCount += 1
    if tapCount == 5 {
      // These calls are fine on MainActor because this class is @MainActor
      persistence.removeAllMedals(context: modelContext)
      medals = persistence.fetchMedals(context: modelContext)
      tapCount = 0
    }
  }

  func stopUpdatingMedals() {
    updateTask?.cancel()
    updateTask = nil
  }

  deinit {
    Task { @MainActor [weak self] in
      // Ensure any running update task is cancelled when the view model is deallocated
      self?.stopUpdatingMedals()
    }
    // Remove observers we registered via tokens
    for token in lifecycleObservers {
      NotificationCenter.default.removeObserver(token)
    }
    lifecycleObservers.removeAll()
  }
}

extension Notification.Name {
  static let medalLeveledUp = Notification.Name("medalLeveledUp")
}
