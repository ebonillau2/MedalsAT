//
//  MedalsATTests.swift
//  MedalsATTests
//
//  Created by Enrique Bonilla on 22/10/25.
//

import Testing
@testable import MedalsAT
import SwiftData

@MainActor
final class MedalViewModelTests {
  
  // MARK: - Test Setup
  
  func makeTestContext() throws -> ModelContext {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Medal.self, configurations: config)
    return container.mainContext
  }
  
  // MARK: - Initialization Tests
  
  @Test func initialization_setsDefaultProperties() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()
    
    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )
    
    #expect(viewModel.medals.isEmpty)
    #expect(viewModel.showToast == false)
    #expect(viewModel.modelContext === context)
  }
  
  @Test func initialization_usesDefaultPersistenceWhenNil() async throws {
    let context = try makeTestContext()
    let viewModel = MedalViewModel(modelContext: context)
    
    #expect(viewModel.persistence is MedalsPersistenceImp)
  }
  
  @Test func initialization_usesMockPersistence() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()

    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    #expect(viewModel.persistence is MockMedalsPersistence)
  }
  
  // MARK: - Start Observing Tests

  @Test func startObservingChanges_loadsMedalsFromMockPersistence() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()

    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    viewModel.startObservingChanges()

    #expect(viewModel.medals.count == 3)
    #expect(viewModel.medals[0].name == "Apostador Novato")
    #expect(viewModel.medals[1].name == "Inversionista Experto")
    #expect(viewModel.medals[0].level == 1)
    #expect(viewModel.medals[1].level == 1)
  }

  // MARK: - Reset Data Tests

  @Test func resetDataIfNeeded_showsToastAndIncrementsTapCount() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()
    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    viewModel.resetDataIfNeeded()

    #expect(viewModel.showToast == true)
    #expect(viewModel.tapCount == 1) // Internal state, might need to be exposed for testing

    // Wait for toast to hide
    try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

    #expect(viewModel.showToast == false)
  }
  
  @Test func resetDataIfNeeded_resetsDataAfterFiveTaps() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()
    
    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )
    
    viewModel.startObservingChanges()
    viewModel.medals = persistence.createInitialData(withLvl: 5)
    #expect(viewModel.medals[0].level == 5)
    #expect(viewModel.medals[1].level == 5)
    
    // Tap 5 times
    for _ in 0..<5 {
      viewModel.resetDataIfNeeded()
    }
    
    #expect(viewModel.medals[0].level == 1)
    #expect(viewModel.medals[1].level == 1)
  }
  
  
  @Test func resetDataIfNeeded_resetsTapCountAfterFiveTaps() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()
    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    // Tap 6 times - should reset after 5th and start counting again
    for _ in 0..<6 {
      viewModel.resetDataIfNeeded()
    }

    // Should reset to 0 after 5th, then increment to 1 on 6th
    #expect(viewModel.tapCount == 1)
  }
  
  
  // MARK: - Medal Update Tests

  @Test func medalUpdate_incrementsPointsOverTime() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()

    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    viewModel.startObservingChanges()
    #expect(viewModel.medals[0].points == 0)
    #expect(viewModel.medals[1].points == 0)

    // Wait for update cycle
    try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 seconds

    #expect(viewModel.medals[0].points > 0)
    #expect(viewModel.medals[1].points > 0)
    #expect(viewModel.medals[0].points < (viewModel.maxIncrementPoints*3)+1)
    #expect(viewModel.medals[1].points < (viewModel.maxIncrementPoints*3)+1)
  }
  
  @Test func medalUpdate_levelsUpWhenPointsReach100() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()

    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    viewModel.startObservingChanges()
    viewModel.medals = persistence.createInitialData(points: 99)
    #expect(viewModel.medals[0].level == 1)
    #expect(viewModel.medals[1].level == 1)

    // Wait for enough update cycles to reach 100 points
    try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

    // Should level up if points reached 100
    #expect(viewModel.medals[0].points < 100)
    #expect(viewModel.medals[1].level > 1)
  }
  
  @Test func medalUpdate_doesNotExceedMaxLevel() async throws {
    let context = try makeTestContext()
    let persistence = MockMedalsPersistence()

    let viewModel = MedalViewModel(
      modelContext: context,
      persistence: persistence
    )

    viewModel.startObservingChanges()
    viewModel.medals = persistence.createInitialData(
      withLvl: persistence.maxLevel - 1,
      points: 99)
    
    // Wait for update cycles
    try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 seconds

    #expect(viewModel.medals[0].points == 0)
    #expect(viewModel.medals[0].level == persistence.maxLevel)
    
    // Make max level with points for testing purposes
    viewModel.medals = persistence.createInitialData(
      withLvl: persistence.maxLevel,
      points: 99)
    
    // Wait for update cycles
    try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
    
    #expect(viewModel.medals[0].level == persistence.maxLevel)
  }
}
