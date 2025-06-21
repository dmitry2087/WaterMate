//      _             _  _                 ____    ___    ___   _____
//   __| | _ __ ___  (_)| |_  _ __  _   _ |___ \  / _ \  ( _ ) |___  |
//  / _` || '_ ` _ \ | || __|| '__|| | | |  __) || | | | / _ \    / /
// | (_| || | | | | || || |_ | |   | |_| | / __/ | |_| || (_) |  / /
//  \__,_||_| |_| |_||_| \__||_|    \__, ||_____| \___/  \___/  /_/
//                                  |___/

// WaterMateApp.swift
// WaterMate
//
// Главная точка входа в приложение (App struct)
// Отвечает за настройку уведомлений и запуск первого экрана

import SwiftUI
import UserNotifications
import AVFoundation

@main
struct WaterReminderApp: App {
    // Запрос разрешения на уведомления при запуске приложения
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    var body: some Scene {
        WindowGroup {
            // Первый экран — SplashScreen
            SplashScreen()
        }
    }
}
