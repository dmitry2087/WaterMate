//
// ContentView.swift
// WaterMate
//
// Created by dmitry2087 on 19.04.2025.
//

import SwiftUI

// Главная точка входа для SwiftUI-превью и тестирования вью
struct ContentView: View {
    var body: some View {
        VStack {
            // Иконка для визуального оформления
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            // Приветственный текст
            Text("Hello, world!")
        }
        .padding() // Общий отступ вокруг содержимого
    }
}

// Превью для Xcode
#Preview {
    ContentView()
}
