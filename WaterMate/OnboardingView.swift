//      _             _  _                 ____    ___    ___   _____
//   __| | _ __ ___  (_)| |_  _ __  _   _ |___ \  / _ \  ( _ ) |___  |
//  / _` || '_ ` _ \ | || __|| '__|| | | |  __) || | | | / _ \    / /
// | (_| || | | | | || || |_ | |   | |_| | / __/ | |_| || (_) |  / /
//  \__,_||_| |_| |_||_| \__||_|    \__, ||_____| \___/  \___/  /_/
//                                  |___/

// OnboardingView.swift
// WaterMate
//
// Экран для ввода возраста и веса пользователя перед расчётом нормы воды

import SwiftUI

struct OnboardingView: View {
    @AppStorage("userAge") private var age: Int = 0
    @AppStorage("userWeight") private var weight: Double = 0.0

    @State private var ageInput: String = ""
    @State private var weightInput: String = ""
    @State private var showMain = false // Управляет переходом к основному экрану

    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Введите ваш возраст и вес")
                .font(.title2)
            // Поле для ввода возраста
            TextField("Возраст (лет)", text: $ageInput)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            // Поле для ввода веса
            TextField("Вес (кг)", text: $weightInput)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            // Кнопка для перехода к расчёту и основному экрану
            Button("Рассчитать норму воды") {
                if let ageInt = Int(ageInput), let weightDouble = Double(weightInput) {
                    age = ageInt
                    weight = weightDouble
                    showMain = true
                }
            }
            .disabled(ageInput.isEmpty || weightInput.isEmpty) // Блокировка кнопки при пустых полях
        }
        .padding()
        // Переход на основной экран с передачей введённых данных
        .fullScreenCover(isPresented: $showMain) {
            MainView()
        }
    }
}
