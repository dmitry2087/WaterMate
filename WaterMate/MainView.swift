//      _             _  _                 ____    ___    ___   _____
//   __| | _ __ ___  (_)| |_  _ __  _   _ |___ \  / _ \  ( _ ) |___  |
//  / _` || '_ ` _ \ | || __|| '__|| | | |  __) || | | | / _ \    / /
// | (_| || | | | | || || |_ | |   | |_| | / __/ | |_| || (_) |  / /
//  \__,_||_| |_| |_||_| \__||_|    \__, ||_____| \___/  \___/  /_/
//                                  |___/

//
// MainView.swift
// WaterMate
// Основной экран приложения с расчётом нормы воды и настройками напоминаний

import SwiftUI
import UserNotifications

struct MainView: View {
    @AppStorage("userAge") private var age: Int = 0 // Возраст пользователя
    @AppStorage("userWeight") private var weight: Double = 0.0 // Вес пользователя

    // Хранение настроек уведомлений через AppStorage
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationsPerDay") private var notificationsPerDay: Int = 4
    @AppStorage("startHour") private var startHour: Int = 9
    @AppStorage("endHour") private var endHour: Int = 21
    @AppStorage("useCustomTimes") private var useCustomTimes: Bool = false
    @State private var customTimes: [Date] = [] // Индивидуальные времена напоминаний

    // Расчёт суточной нормы воды (мл)
    var waterIntake: Double {
        return weight * 30
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Заголовок и результат расчёта нормы воды
                    Text("Ваша суточная норма воды:")
                        .font(.title2)
                        .padding(.top, 16)

                    Text("\(String(format: "%.2f", Double(waterIntake)/1000)) л")
                        .font(.largeTitle)
                        .bold()

                    // Переключатель уведомлений
                    Toggle("Напоминания о приеме воды", isOn: $notificationsEnabled)
                        .padding()
                        .onChange(of: notificationsEnabled) { enabled in
                            if enabled {
                                scheduleNotifications()
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }

                    // Переключатель использования точного времени
                    Toggle("Использовать точное время", isOn: $useCustomTimes)
                        .onChange(of: useCustomTimes) { _ in
                            if notificationsEnabled {
                                scheduleNotifications()
                            }
                        }

                    // Блок настройки времени напоминаний
                    if useCustomTimes {
                        VStack(spacing: 12) {
                            // Для каждого напоминания — свой DatePicker
                            ForEach(0..<notificationsPerDay, id: \.self) { index in
                                DatePicker(
                                    "Время \(index + 1)",
                                    selection: Binding(
                                        get: {
                                            if customTimes.indices.contains(index) {
                                                return customTimes[index]
                                            } else {
                                                let calendar = Calendar.current
                                                let defaultHour = startHour + (endHour - startHour) * index / max(notificationsPerDay - 1, 1)
                                                return calendar.date(bySettingHour: defaultHour, minute: 0, second: 0, of: Date()) ?? Date()
                                            }
                                        },
                                        set: { newValue in
                                            if customTimes.indices.contains(index) {
                                                customTimes[index] = newValue
                                            } else if customTimes.count == index {
                                                customTimes.append(newValue)
                                            }
                                        }
                                    ),
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Настройка количества и диапазона времени напоминаний
                        VStack(spacing: 12) {
                            Stepper("Количество напоминаний: \(notificationsPerDay)", value: $notificationsPerDay, in: 1...12)
                            HStack {
                                Text("Начало:")
                                Spacer()
                                Stepper("\(startHour):00", value: $startHour, in: 0...23)
                            }
                            HStack {
                                Text("Окончание:")
                                Spacer()
                                Stepper("\(endHour):00", value: $endHour, in: 0...23)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Кнопка перехода к настройкам возраста и веса
                    NavigationLink(destination: SettingsView()) {
                        Text("Изменить возраст и вес")
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }

                    Spacer(minLength: 24) // Отступ внизу для красоты
                }
                .padding(.horizontal)
            }
            .navigationTitle("Главная")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // Функция для планирования уведомлений
    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        if useCustomTimes {
            // Уведомления по индивидуальным временам
            for time in customTimes.prefix(notificationsPerDay) {
                let components = Calendar.current.dateComponents([.hour, .minute], from: time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let content = UNMutableNotificationContent()
                content.title = "Напоминание"
                content.body = "Время выпить воды 💧"
                content.sound = .default
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        } else {
            // Уведомления по равным интервалам между startHour и endHour
            guard endHour > startHour else { return }
            let interval = Double(endHour - startHour) / Double(notificationsPerDay)
            for i in 0..<notificationsPerDay {
                let hour = startHour + Int(round(interval * Double(i)))
                var components = DateComponents()
                components.hour = hour
                components.minute = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let content = UNMutableNotificationContent()
                content.title = "Напоминание"
                content.body = "Время выпить воды 💧"
                content.sound = .default
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
}
