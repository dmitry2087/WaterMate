//      _             _  _                 ____    ___    ___   _____
//   __| | _ __ ___  (_)| |_  _ __  _   _ |___ \  / _ \  ( _ ) |___  |
//  / _` || '_ ` _ \ | || __|| '__|| | | |  __) || | | | / _ \    / /
// | (_| || | | | | || || |_ | |   | |_| | / __/ | |_| || (_) |  / /
//  \__,_||_| |_| |_||_| \__||_|    \__, ||_____| \___/  \___/  /_/
//                                  |___/

// SplashScreen.swift
// WaterMate

// Экран-заставка с анимацией при запуске приложения

import SwiftUI

struct SplashScreen: View {
    @AppStorage("userAge") private var age: Int = 0
    @AppStorage("userWeight") private var weight: Double = 0.0
    @State private var isActive = false // Управляет переходом к следующему экрану
    @State private var scale: CGFloat = 0.8 // Начальный масштаб для анимации
    @State private var opacity: Double = 0.5 // Начальная прозрачность для анимации
    
    var body: some View {
        Group {
            if isActive {
                // После заставки показывается экран онбординга или основной экран, если данные уже есть
                if age > 0 && weight > 0 {
                    MainView()
                } else {
                    OnboardingView()
                }
            } else {
                VStack {
                    Spacer()
                    
                    // Логотип приложения с анимацией
                    Text("💧 WaterMate")
                        .font(.system(size: 48, weight: .bold))
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            // Анимация появления
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.scale = 1.0
                                self.opacity = 1.0
                            }
                        }
                    
                    Spacer()
                    
                    // Кнопка для перехода на следующий экран
                    Button("Продолжить") {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
                .padding()
                .transition(.opacity)
            }
        }
    }
}
