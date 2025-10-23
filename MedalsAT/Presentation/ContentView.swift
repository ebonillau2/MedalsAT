//
//  ContentView.swift
//  MedalsAT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  var body: some View {

    NavigationView {
      List {
        Section(header: Text("🏅 Medallas")) {
          ForEach(0..<10) { i in
            Text("Sample \(i)")
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

#Preview {
  ContentView()
}
