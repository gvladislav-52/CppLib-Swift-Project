//
//  JsonTestApp.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import SwiftUI

@main
struct JsonTestApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

import SwiftUI

// MARK: - Главная страница выбора
struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Выберите экран")
                    .font(.largeTitle)
                    .bold()
                
                NavigationLink("Рандомные имена") {
                    RandomUsersView()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                NavigationLink("Rick & Morty") {
                    RickAndMortyView()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Spacer()
            }
            .padding()
        }
    }
}
