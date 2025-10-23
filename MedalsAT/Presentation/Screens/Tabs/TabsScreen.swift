//
//  TabsScreen.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import SwiftData

struct TabsScreen: View {

  let container: ModelContainer = {
    do {
      // Create a persistent container for your @Model types
      return try ModelContainer(for: Medal.self)
    } catch {
      fatalError("❌ Failed to create ModelContainer: \(error)")
    }
  }()

  var body: some View {
    TabView {
      Tab("Perfil", systemImage: "person") {
        HomeScreen(modelContext: container.mainContext)
          .modelContainer(container)
      }

      Tab("Configuracion", systemImage: "gear") {
        SettingsScreen()
      }
    }
    .setAppearanceTheme()
  }
}

// MARK: - helper to set saved theme

extension View {
  func setAppearanceTheme() -> some View {
    modifier(AppearanceThemeViewModifier())
  }
}

struct AppearanceThemeViewModifier: ViewModifier {

  @AppStorage(UserDefaultsKeys.appearanceTheme) private var appearanceTheme: AppearanceTheme = .system

  func body(content: Content) -> some View {
    content
      .preferredColorScheme(scheme())
  }

  func scheme() -> ColorScheme? {
    switch appearanceTheme {
    case .dark: return .dark
    case .light: return .light
    case .system: return nil
    }
  }
}

#Preview {
  TabsScreen()
}
