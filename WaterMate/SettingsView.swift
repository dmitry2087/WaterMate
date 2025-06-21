//      _             _  _                 ____    ___    ___   _____
//   __| | _ __ ___  (_)| |_  _ __  _   _ |___ \  / _ \  ( _ ) |___  |
//  / _` || '_ ` _ \ | || __|| '__|| | | |  __) || | | | / _ \    / /
// | (_| || | | | | || || |_ | |   | |_| | / __/ | |_| || (_) |  / /
//  \__,_||_| |_| |_||_| \__||_|    \__, ||_____| \___/  \___/  /_/
//                                  |___/

// SettingsView.swift
// WaterMate
//
// Экран для изменения возраста и веса пользователя

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode // Для закрытия экрана

    @AppStorage("userAge") private var currentAge: Int = 0 // Ссылка на текущий возраст
    @AppStorage("userWeight") private var currentWeight: Double = 0.0 // Ссылка на текущий вес

    @State private var age: String = "" // Локальное поле для ввода возраста
    @State private var weight: String = "" // Локальное поле для ввода веса

    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Измените ваши данные")
                .font(.title2)
            // Поле для ввода нового возраста
            TextField("Новый возраст", text: $age)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            // Поле для ввода нового веса
            TextField("Новый вес", text: $weight)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            // Кнопка сохранения изменений
            Button("Сохранить") {
                if let newAge = Int(age), let newWeight = Double(weight) {
                    currentAge = newAge
                    currentWeight = newWeight
                    presentationMode.wrappedValue.dismiss() // Закрытие экрана
                }
            }
            .disabled(age.isEmpty || weight.isEmpty) // Блокировка кнопки при пустых полях
        }
        .padding()
        // Подстановка текущих значений при открытии экрана
        .onAppear {
            age = "\(currentAge)"
            weight = "\(currentWeight)"
        }
    }
}
