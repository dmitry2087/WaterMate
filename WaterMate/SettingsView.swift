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
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("userAge") private var currentAge: Int = 0
    @AppStorage("userWeight") private var currentWeight: Double = 0.0
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var showValidationError = false
    @State private var errorMessage = ""
    
    // Константы для валидации
    private let maxAge = 150
    private let maxWeight = 500.0
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Измените ваши данные")
                .font(.title2)
            
            // Поле для ввода нового возраста
            VStack(alignment: .leading) {
                TextField("Новый возраст", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                Text("Максимальный возраст: \(maxAge) лет")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Поле для ввода нового веса
            VStack(alignment: .leading) {
                TextField("Новый вес", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                
                Text("Максимальный вес: \(Int(maxWeight)) кг")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Сообщение об ошибке валидации
            if showValidationError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Кнопка сохранения изменений
            Button("Сохранить") {
                saveChanges()
            }
            .disabled(age.isEmpty || weight.isEmpty)
            
            Spacer()
            
            // Блок с версией приложения и ссылкой на GitHub
            VStack(spacing: 12) {
                Divider()
                
                // Версия приложения
                Text("Версия приложения: v1.0.1")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                // Кнопка GitHub
                Button(action: {
                    if let url = URL(string: "https://github.com/dmitry2087/WaterMate") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "link")
                        Text("GitHub Repository")
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
        .onAppear {
            age = "\(currentAge)"
            weight = "\(currentWeight)"
        }
        .alert("Ошибка", isPresented: $showValidationError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // Функция сохранения с валидацией
    private func saveChanges() {
        guard let newAge = Int(age), let newWeight = Double(weight) else {
            showError("Введите корректные числовые значения")
            return
        }
        
        // Проверка на отрицательные значения
        if newAge < 0 || newWeight < 0 {
            showError("Значения не могут быть отрицательными")
            return
        }
        
        // Проверка максимальных значений
        if newAge > maxAge {
            showError("Возраст не может превышать \(maxAge) лет")
            return
        }
        
        if newWeight > maxWeight {
            showError("Вес не может превышать \(Int(maxWeight)) кг")
            return
        }
        
        // Проверка минимальных разумных значений
        if newAge < 1 {
            showError("Возраст должен быть больше 0")
            return
        }
        
        if newWeight < 1 {
            showError("Вес должен быть больше 0")
            return
        }
        
        // Сохранение валидных данных
        currentAge = newAge
        currentWeight = newWeight
        presentationMode.wrappedValue.dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showValidationError = true
    }
}
