//
//  MedalsATApp.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import SwiftData
import Combine

@main
struct Medals_ATApp: App {
  
  let container: ModelContainer = {
    do {
      // Create a persistent container for your @Model types
      return try ModelContainer(for: Medal.self)
    } catch {
      fatalError("❌ Failed to create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      // Pass the ModelContext from this container into ContentView
      ContentView(modelContext: container.mainContext)
        .modelContainer(container)
    }
  }
}
