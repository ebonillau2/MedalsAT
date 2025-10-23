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
  
//  @State private var tapCount = 0
  
  init(modelContext: ModelContext) {
    _viewModel = StateObject(wrappedValue: MedalViewModel(modelContext: modelContext))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          topView
          listView
        }
        .listStyle(.insetGrouped)
      }
    }
    .navigationTitle("Perfil de Usuario")
    .toolbarTitleDisplayMode(.inline)
    
  }
}

// Views
private extension ContentView {
  var topView: some View {
    HStack(spacing: 12,) {
      Button {
        withAnimation {
          viewModel.resetDataIfNeeded()
        }
      } label: {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 55, height: 55)
          .foregroundColor(.blue)
      }
      .frame(width: 55, height: 55)
      Text("Bienvenido")
        .font(.title2)
        .fontWeight(.semibold)
    }
  }
  
  @ViewBuilder
  var listView: some View {
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
