//
//  UIOverlayAdvancedExamples.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

// MARK: - Advanced Features Demo

struct UIOverlayAdvancedFeaturesDemo: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Auto-Dismiss Success") {
                    AutoDismissSuccessExample()
                }

                NavigationLink("Close Button with Empty") {
                    CloseButtonEmptyExample()
                }

                NavigationLink("Solid Color Overlay") {
                    SolidColorOverlayExample()
                }

                NavigationLink("Custom Icons") {
                    CustomIconsExample()
                }

                NavigationLink("Combined Features") {
                    CombinedFeaturesExample()
                }
            }
            .navigationTitle("Advanced Overlay Features")
        }
    }
}

// MARK: - Auto-Dismiss Example

struct AutoDismissSuccessExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Auto-Dismiss Demo")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Success will auto-dismiss after 2 seconds")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Success (Auto-Dismiss)") {
                uiState = .success(message: "Operation completed successfully!")
            }
            .buttonStyle(.borderedProminent)

            Text("Current State: \(stateDescription)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                showCloseButton: true,
                autoDismissAfter: 2.0
            )
        )
        .onChange(of: uiState) { _ in
            print("Auto-dismiss triggered, state changed to: \(stateDescription)")
        }
    }

    private var stateDescription: String {
        switch uiState {
        case .idle: return "Idle"
        case .loading: return "Loading"
        case .empty: return "Empty"
        case .failure: return "Failed"
        case .success: return "Success (will auto-dismiss)"
        case .custom(let id, _): return "Custom(id: \(id))"
        case .rive: return "Rive Animation"
        }
    }
}

// MARK: - Close Button Example

struct CloseButtonEmptyExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Close Button Demo")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Click the X button to dismiss")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Empty State") {
                uiState = .empty(message: "Your library is empty. Add some items to get started!")
            }
            .buttonStyle(.borderedProminent)

            Text("Current State: \(stateDescription)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
        .uiOverlay(
            state: $uiState,
            configuration: .glassWithClose
        )
        .onChange(of: uiState) { _ in
            print("Close button tapped, state changed to: \(stateDescription)")
        }
    }

    private var stateDescription: String {
        switch uiState {
        case .idle: return "Idle"
        case .loading: return "Loading"
        case .empty: return "Empty (click X to dismiss)"
        case .failure: return "Failed"
        case .success: return "Success"
        case .custom(let id, _): return "Custom(id: \(id))"
        case .rive: return "Rive Animation"
        }
    }
}

// MARK: - Solid Color Example

struct SolidColorOverlayExample: View {
    @State private var uiState: UIState = .idle
    @State private var selectedColor: OverlayColor = .purple

    enum OverlayColor: String, CaseIterable {
        case purple = "Purple"
        case blue = "Blue"
        case green = "Green"
        case red = "Red"
        case black = "Black"

        var color: Color {
            switch self {
            case .purple: return .purple
            case .blue: return .blue
            case .green: return .green
            case .red: return .red
            case .black: return .black
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Solid Color Overlay")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Choose your overlay color")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("Color", selection: $selectedColor) {
                ForEach(OverlayColor.allCases, id: \.self) { color in
                    Text(color.rawValue).tag(color)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Button("Show \(selectedColor.rawValue) Overlay") {
                uiState = .success(message: "Custom \(selectedColor.rawValue.lowercased()) overlay!")
            }
            .buttonStyle(.borderedProminent)
            .tint(selectedColor.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .solid(backgroundColor: selectedColor.color, opacity: 0.95),
                showCloseButton: true,
                autoDismissAfter: 3.0
            )
        )
    }
}

// MARK: - Custom Icons Example

struct CustomIconsExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Icons Demo")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Each state has a custom icon")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                Button("Custom Success Icon") {
                    uiState = .success(message: "Achievement Unlocked!") {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 70, height: 70)

                            Image(systemName: "trophy.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                Button("Custom Failure Icon") {
                    uiState = .failure(message: "Upload failed. Please try again.") {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 70, height: 70)

                            Image(systemName: "icloud.slash.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.red)
                        }
                    }
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button("Custom Empty Icon") {
                    uiState = .empty(message: "No notifications yet") {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 70, height: 70)

                            Image(systemName: "bell.slash.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                showCloseButton: true,
                autoDismissAfter: 3.0
            )
        )
    }
}

// MARK: - Combined Features Example

struct CombinedFeaturesExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("All Features Combined")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Custom icon + Solid color + Auto-dismiss + Close button")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Show Premium Success") {
                uiState = .success(message: "Premium feature unlocked! Enjoy your upgrade.") {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 70)

                        Image(systemName: "crown.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)

            VStack(alignment: .leading, spacing: 4) {
                Text("Features Active:")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("✓ Custom gradient icon")
                    .font(.caption2)
                Text("✓ Indigo solid background")
                    .font(.caption2)
                Text("✓ Auto-dismiss after 4 seconds")
                    .font(.caption2)
                Text("✓ Close button (top-right)")
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .solid(
                    backgroundColor: .indigo,
                    opacity: 0.95,
                    backdropOpacity: 0.5,
                    cornerRadius: 24
                ),
                showCloseButton: true,
                autoDismissAfter: 4.0
            )
        )
        .onChange(of: uiState) { _ in
            print("Overlay dismissed (auto or manual)")
        }
    }
}

#Preview("Advanced Features") {
    UIOverlayAdvancedFeaturesDemo()
}

#Preview("Auto-Dismiss") {
    AutoDismissSuccessExample()
}

#Preview("Close Button") {
    CloseButtonEmptyExample()
}

#Preview("Solid Colors") {
    SolidColorOverlayExample()
}

#Preview("Custom Icons") {
    CustomIconsExample()
}

#Preview("Combined") {
    CombinedFeaturesExample()
}
