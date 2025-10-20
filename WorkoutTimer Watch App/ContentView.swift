//
//  ContentView.swift
//  WorkoutTimer Watch App
//
//  Created by Fatom on 2025-10-20.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var selectedPresetIndex = 1

    let presets: [TimeInterval] = [60, 5*60, 10*60, 20*60, 30*60]
    let presetLabels: [String]   = ["1m","5m","10m","20m","30m"]

    var body: some View {
        VStack(spacing: 10) {

            // 1️⃣ Custom segmented control using HStack buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(0..<presetLabels.count, id: \.self) { index in
                        Button {
                            selectedPresetIndex = index
                            timerManager.setDuration(presets[index])
                        } label: {
                            Text(presetLabels[index])
                                .font(.system(size: 14, weight: .medium))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(selectedPresetIndex == index ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(selectedPresetIndex == index ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
            }

            // 2️⃣ Timer label
            Text(timerManager.formattedRemaining())
                .font(.system(size: 32, weight: .semibold, design: .rounded))

            // 3️⃣ Progress ring
            ProgressView(value: timerManager.progress)
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.2)
                .frame(width: 80, height: 80)

            // 4️⃣ Controls
            HStack(spacing: 10) {
                Button(action: { timerManager.toggle() }) {
                    Label(timerManager.isRunning ? "Pause" : "Start",
                          systemImage: timerManager.isRunning ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.borderedProminent)

                Button(action: { timerManager.reset() }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onAppear {
            timerManager.setDuration(presets[selectedPresetIndex])
            requestNotificationPermissionIfNeeded()
        }
    }

    private func requestNotificationPermissionIfNeeded() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus != .authorized else { return }
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

