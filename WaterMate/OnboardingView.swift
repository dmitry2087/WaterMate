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
    @State private var showMain = false
    @State private var showValidationError = false
    @State private var errorMessage = ""
    
    // Константы для валидации
    private let maxAge = 150
    private let maxWeight = 500.0
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Введите ваш возраст и вес")
                .font(.title2)
            
            // Поле для ввода возраста
            VStack(alignment: .leading) {
                TextField("Возраст (лет)", text: $ageInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                Text("От 1 до \(maxAge) лет")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Поле для ввода веса
            VStack(alignment: .leading) {
                TextField("Вес (кг)", text: $weightInput)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                
                Text("От 1 до \(Int(maxWeight)) кг")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Сообщение об ошибке валидации
            if showValidationError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Кнопка для перехода к расчёту и основному экрану
            Button("Рассчитать норму воды") {
                validateAndSave()
            }
            .disabled(ageInput.isEmpty || weightInput.isEmpty)
        }
        .padding()
        .alert("Ошибка", isPresented: $showValidationError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showMain) {
            MainView()
        }
    }
    
    private func validateAndSave() {
        guard let ageInt = Int(ageInput), let weightDouble = Double(weightInput) else {
            showError("Введите корректные числовые значения")
            return
        }
        
        // Проверка на отрицательные значения
        if ageInt < 0 || weightDouble < 0 {
            showError("Значения не могут быть отрицательными")
            return
        }
        
        // Проверка максимальных значений
        if ageInt > maxAge {
            showError("Возраст не может превышать \(maxAge) лет")
            return
        }
        
        if weightDouble > maxWeight {
            showError("Вес не может превышать \(Int(maxWeight)) кг")
            return
        }
        
        // Проверка минимальных разумных значений
        if ageInt < 1 {
            showError("Возраст должен быть больше 0")
            return
        }
        
        if weightDouble < 1 {
            showError("Вес должен быть больше 0")
            return
        }
        
        // Сохранение валидных данных
        age = ageInt
        weight = weightDouble
        showMain = true
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showValidationError = true
    }
}
