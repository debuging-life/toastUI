//
//  UIOverlayDebugTest.swift
//  ToastUI
//
//  Created for debugging auto-dismiss and close button
//

import SwiftUI

struct UIOverlayDebugTestView: View {
    @State private var uiState: UIState = .idle
    @State private var showLog: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Debug Test View")
                .font(.title)
                .fontWeight(.bold)

            Text("Current State: \(currentStateString)")
                .font(.headline)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 12) {
                Button("Show Success (Auto-Dismiss 2s)") {
                    addLog("Button tapped: Setting state to .success")
                    uiState = .success(message: "This will auto-dismiss in 2 seconds")
                    addLog("State is now: \(currentStateString)")
                }
                .buttonStyle(.borderedProminent)

                Button("Show Failure (With Close Button)") {
                    addLog("Button tapped: Setting state to .failure")
                    uiState = .failure(message: "Click the X button to close")
                    addLog("State is now: \(currentStateString)")
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button("Show Empty (Both Features)") {
                    addLog("Button tapped: Setting state to .empty")
                    uiState = .empty(message: "Auto-dismiss OR tap X")
                    addLog("State is now: \(currentStateString)")
                }
                .buttonStyle(.bordered)
                .tint(.orange)

                Button("Manually Set to Idle") {
                    addLog("Manual reset: Setting state to .idle")
                    uiState = .idle
                    addLog("State is now: \(currentStateString)")
                }
                .buttonStyle(.bordered)
                .tint(.gray)

                Button("Clear Log") {
                    showLog.removeAll()
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Event Log:")
                        .font(.caption)
                        .fontWeight(.bold)

                    ForEach(Array(showLog.enumerated()), id: \.offset) { index, log in
                        Text("\(index + 1). \(log)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                showCloseButton: true,
                autoDismissAfter: 2.0
            )
        )
        .onChange(of: uiState) { newValue in
            addLog("🔥 State CHANGED to: \(currentStateString)")
        }
        .navigationTitle("Debug Test")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var currentStateString: String {
        switch uiState {
        case .idle: return "idle"
        case .loading(let message, _): return "loading(\(message ?? "nil"))"
        case .empty(let message, _): return "empty(\(message))"
        case .failure(let message, _): return "failure(\(message))"
        case .success(let message, _): return "success(\(message))"
        case .custom(let id, _): return "custom(id: \(id))"
        case .rive(let id, let riveName, _, _, let title, _): return "rive(id: \(id), name: \(riveName), title: \(title ?? "nil"))"
        }
    }

    private func addLog(_ message: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        showLog.append("[\(timestamp)] \(message)")
        print("📝 \(message)")
    }
}

#Preview {
    NavigationView {
        UIOverlayDebugTestView()
    }
}
