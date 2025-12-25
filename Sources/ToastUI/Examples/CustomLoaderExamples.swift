//
//  CustomLoaderExamples.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

// MARK: - Custom Loader Examples

/// Example 1: Bouncing Dots Loader
struct BouncingDotsLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Bouncing Dots Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Start Loading") {
                startLoading()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass()
            )
        )
    }

    func startLoading() {
        uiState = .loading(message: "Fetching data...") {
            BouncingDotsLoader()
        }

        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            uiState = .success(message: "Data loaded!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiState = .idle
        }
    }
}

/// Bouncing Dots Loader View
struct BouncingDotsLoader: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 12, height: 12)
                    .offset(y: animating ? -15 : 0)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

/// Example 2: Pulsing Circle Loader
struct PulsingCircleLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Pulsing Circle Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Upload File") {
                uploadFile()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(state: $uiState)
    }

    func uploadFile() {
        uiState = .loading(message: "Uploading file...") {
            PulsingCircleLoader()
        }

        // Simulate upload
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            uiState = .success(message: "File uploaded successfully!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            uiState = .idle
        }
    }
}

/// Pulsing Circle Loader View
struct PulsingCircleLoader: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                    .scaleEffect(scale + CGFloat(index) * 0.3)
                    .opacity(opacity - Double(index) * 0.3)
            }
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                scale = 1.5
                opacity = 0
            }
        }
    }
}

/// Example 3: Spinning Squares Loader
struct SpinningSquaresLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Spinning Squares Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Process Data") {
                processData()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass()
            )
        )
    }

    func processData() {
        uiState = .loading(message: "Processing...") {
            SpinningSquaresLoader()
        }

        // Simulate processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            uiState = .success(message: "Processing complete!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            uiState = .idle
        }
    }
}

/// Spinning Squares Loader View
struct SpinningSquaresLoader: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: 20, height: 20)
                    .offset(x: 20)
                    .rotationEffect(.degrees(Double(index) * 90 + rotation))
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

/// Example 4: Arc Spinner Loader
struct ArcSpinnerLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Arc Spinner Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Sync Data") {
                syncData()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(state: $uiState)
    }

    func syncData() {
        uiState = .loading(message: "Syncing...") {
            ArcSpinnerLoader()
        }

        // Simulate sync
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            uiState = .success(message: "Synced successfully!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiState = .idle
        }
    }
}

/// Arc Spinner Loader View
struct ArcSpinnerLoader: View {
    @State private var rotation: Double = 0
    @State private var trimEnd: CGFloat = 0.7

    var body: some View {
        Circle()
            .trim(from: 0, to: trimEnd)
            .stroke(
                LinearGradient(
                    colors: [.green, .teal],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    .linear(duration: 1.0)
                    .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }

                withAnimation(
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
                ) {
                    trimEnd = 0.2
                }
            }
    }
}

/// Example 5: DNA Helix Loader
struct DNAHelixLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("DNA Helix Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Analyze") {
                analyze()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(state: $uiState)
    }

    func analyze() {
        uiState = .loading(message: "Analyzing data...") {
            DNAHelixLoader()
        }

        // Simulate analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            uiState = .success(message: "Analysis complete!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            uiState = .idle
        }
    }
}

/// DNA Helix Loader View
struct DNAHelixLoader: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .offset(x: sin(offset + Double(index) * 0.5) * 10)
                }
            }

            VStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 8, height: 8)
                        .offset(x: sin(offset + Double(index) * 0.5 + .pi) * 10)
                }
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 2.0)
                .repeatForever(autoreverses: false)
            ) {
                offset = .pi * 4
            }
        }
    }
}

/// Example 6: Default Loader (No Custom Loader)
struct DefaultLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Default Loader")
                .font(.title2)
                .fontWeight(.bold)

            Text("Uses the built-in gradient circle loader")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Use Default") {
                useDefault()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(state: $uiState)
    }

    func useDefault() {
        // No custom loader - uses default
        uiState = .loading(message: "Loading with default...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            uiState = .success(message: "Done!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiState = .idle
        }
    }
}

/// Example 7: ProgressView System Loader
struct ProgressViewLoaderExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("System ProgressView Loader")
                .font(.title2)
                .fontWeight(.bold)

            Button("Use ProgressView") {
                useProgressView()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .uiOverlay(state: $uiState)
    }

    func useProgressView() {
        uiState = .loading(message: "Loading...") {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
                .tint(.blue)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            uiState = .success(message: "Loaded!")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiState = .idle
        }
    }
}

// MARK: - Preview

#Preview("Bouncing Dots") {
    BouncingDotsLoaderExample()
}

#Preview("Pulsing Circle") {
    PulsingCircleLoaderExample()
}

#Preview("Spinning Squares") {
    SpinningSquaresLoaderExample()
}

#Preview("Arc Spinner") {
    ArcSpinnerLoaderExample()
}

#Preview("DNA Helix") {
    DNAHelixLoaderExample()
}

#Preview("Default Loader") {
    DefaultLoaderExample()
}

#Preview("ProgressView") {
    ProgressViewLoaderExample()
}
