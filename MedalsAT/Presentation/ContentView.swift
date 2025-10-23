//
//  ContentView.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) var modelContext
  @StateObject var viewModel: MedalViewModel
  
  init(modelContext: ModelContext) {
    _viewModel = StateObject(wrappedValue: MedalViewModel(modelContext: modelContext))
  }
  
  var body: some View {

    NavigationView {
      List {
        Section(header: Text("🏅 Medallas")) {
          ForEach(viewModel.medals) { medal in
            MedalRowView(medal: medal)
          }
        }
        
        Section(header: Text("🎯 Misiones")) {
          Text("Próximamente...").foregroundStyle(.secondary)
        }
        
        Section(header: Text("🔥 Rachas")) {
          Text("Próximamente...").foregroundStyle(.secondary)
        }
        
        Section(header: Text("📸 Álbum")) {
          Text("Próximamente...").foregroundStyle(.secondary)
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Perfil de Usuario")
    }

  }
}

// Temporary container for preview
let previewContainer: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Medal.self, configurations: config)
    return container
}()

#Preview {
  ContentView(modelContext: previewContainer.mainContext)
}
