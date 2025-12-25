//
//  UIOverlayConfigurationExamples.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 25/12/25.
//

import SwiftUI

// MARK: - Clean Configuration Examples

struct UIOverlayConfigurationExamples: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("UIOverlay Configuration Examples")
                    .font(.title)
                    .padding()

                // Example 1: Simple text style customization
                ConfigExample1(uiState: $uiState)

                // Example 2: Using presets
                ConfigExample2(uiState: $uiState)

                // Example 3: Complete custom configuration
                ConfigExample3(uiState: $uiState)

                // Example 4: Dark themed overlay
                ConfigExample4(uiState: $uiState)

                // Example 5: Large bold text
                ConfigExample5(uiState: $uiState)
            }
            .padding()
        }
    }
}

// MARK: - Example 1: Simple Text Style Customization

struct ConfigExample1: View {
    @Binding var uiState: UIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("1. Simple Text Style")
                .font(.headline)

            Text("Clean and readable configuration using TextStyleConfiguration")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Loading") {
                uiState = .loading(message: "Processing your request...")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                titleStyle: TextStyleConfiguration(
                    color: .blue,
                    font: .title3,
                    fontWeight: .bold
                ),
                messageStyle: TextStyleConfiguration(
                    color: .gray,
                    font: .body,
                    fontWeight: .regular
                )
            )
        )
    }
}

// MARK: - Example 2: Using Presets

struct ConfigExample2: View {
    @Binding var uiState: UIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("2. Using Text Style Presets")
                .font(.headline)

            Text("Use built-in presets for common styles")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("Default") {
                    uiState = .success(message: "Using default text styles")
                }
                .buttonStyle(.bordered)

                Button("Large Bold") {
                    uiState = .success(message: "Using large bold title")
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                titleStyle: .largeBoldTitle,
                messageStyle: .smallLightMessage
            )
        )
    }
}

// MARK: - Example 3: Complete Custom Configuration

struct ConfigExample3: View {
    @Binding var uiState: UIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("3. Complete Custom Configuration")
                .font(.headline)

            Text("Full control over all styling aspects")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Error") {
                uiState = .failure(message: "Connection timeout. Please try again.")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .solid(
                    backgroundColor: .white,
                    opacity: 1.0,
                    backdropOpacity: 0.5,
                    cornerRadius: 24,
                    maxWidth: 380
                ),
                titleStyle: TextStyleConfiguration(
                    color: .red,
                    font: .title2,
                    fontWeight: .heavy
                ),
                messageStyle: TextStyleConfiguration(
                    color: .black.opacity(0.7),
                    font: .callout,
                    fontWeight: .medium
                ),
                showCloseButton: true
            )
        )
    }
}

// MARK: - Example 4: Dark Themed Overlay

struct ConfigExample4: View {
    @Binding var uiState: UIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("4. Dark Theme Configuration")
                .font(.headline)

            Text("Perfect for dark mode interfaces")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Empty State") {
                uiState = .empty(message: "No messages found in your inbox")
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .solid(
                    backgroundColor: .black,
                    opacity: 0.95,
                    backdropOpacity: 0.4
                ),
                titleStyle: TextStyleConfiguration(
                    color: .white,
                    font: .headline,
                    fontWeight: .semibold
                ),
                messageStyle: TextStyleConfiguration(
                    color: .white.opacity(0.7),
                    font: .subheadline,
                    fontWeight: .regular
                ),
                showCloseButton: true
            )
        )
    }
}

// MARK: - Example 5: Large Bold Text Style

struct ConfigExample5: View {
    @Binding var uiState: UIState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5. Impactful Large Text")
                .font(.headline)

            Text("Make important messages stand out")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Show Success") {
                uiState = .success(message: "Your payment has been processed successfully!")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                titleStyle: TextStyleConfiguration(
                    color: .green,
                    font: .largeTitle,
                    fontWeight: .black
                ),
                messageStyle: TextStyleConfiguration(
                    color: .primary,
                    font: .title3,
                    fontWeight: .medium
                ),
                autoDismissAfter: 3.0
            )
        )
    }
}

// MARK: - Advanced: Creating Custom Text Style Presets

extension TextStyleConfiguration {
    /// Custom preset: Error text style
    static let errorStyle = TextStyleConfiguration(
        color: .red,
        font: .title3,
        fontWeight: .bold
    )

    /// Custom preset: Success text style
    static let successStyle = TextStyleConfiguration(
        color: .green,
        font: .headline,
        fontWeight: .semibold
    )

    /// Custom preset: Warning text style
    static let warningStyle = TextStyleConfiguration(
        color: .orange,
        font: .title3,
        fontWeight: .semibold
    )

    /// Custom preset: Info text style
    static let infoStyle = TextStyleConfiguration(
        color: .blue,
        font: .body,
        fontWeight: .regular
    )
}

// MARK: - Usage Example with Custom Presets

struct CustomPresetsExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Text Style Presets")
                .font(.title2)

            HStack(spacing: 12) {
                Button("Error") {
                    uiState = .failure(message: "Authentication failed")
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button("Success") {
                    uiState = .success(message: "Profile updated")
                }
                .buttonStyle(.bordered)
                .tint(.green)

                Button("Warning") {
                    uiState = .empty(message: "Low storage space")
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }
        }
        .padding()
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                titleStyle: .errorStyle,  // Using custom preset
                messageStyle: .infoStyle,  // Using custom preset
                showCloseButton: true
            )
        )
    }
}

#Preview("Configuration Examples") {
    UIOverlayConfigurationExamples()
}

#Preview("Custom Presets") {
    CustomPresetsExample()
}
