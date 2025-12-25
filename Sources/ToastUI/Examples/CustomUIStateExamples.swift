//
//  CustomUIStateExamples.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

// MARK: - Custom View Examples

/// Example 1: Custom Rating Overlay
struct RatingOverlayExample: View {
    @State private var uiState: UIState = .idle
    @State private var rating = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Rating Example")
                .font(.title)

            Button("Show Rating") {
                rating = 0
                uiState = .custom(id: "rating") {
                    VStack(spacing: 20) {
                        Text("Rate Your Experience")
                            .font(.title2)
                            .fontWeight(.bold)

                        // Star rating
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button {
                                    rating = star
                                } label: {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 32))
                                        .foregroundStyle(star <= rating ? .yellow : .gray)
                                }
                            }
                        }

                        if rating > 0 {
                            Text("Selected: \(rating) stars")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                showCloseButton: true,
                autoDismissAfter: nil
            )
        )
    }
}

/// Example 2: Custom Card with Gradient
struct GradientCardExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Gradient Card Example")
                .font(.title)

            Button("Show Offer") {
                uiState = .custom(id: "offer") {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                            )

                        Text("Special Offer!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Get 50% off on your first purchase")
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)

                        Button {
                            print("Offer claimed!")
                        } label: {
                            Text("Claim Offer")
                                .font(.headline)
                                .foregroundStyle(.indigo)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .solid(
                    backgroundColor: .indigo,
                    opacity: 0.95,
                    cornerRadius: 24
                ),
                showCloseButton: true
            )
        )
    }
}

/// Example 3: Custom Form Overlay
struct CustomFormExample: View {
    @State private var uiState: UIState = .idle
    @State private var name = ""
    @State private var email = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Form Example")
                .font(.title)

            Button("Open Form") {
                name = ""
                email = ""
                uiState = .custom(id: "form") {
                    VStack(spacing: 20) {
                        Text("Contact Form")
                            .font(.title2)
                            .fontWeight(.bold)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TextField("Enter your name", text: $name)
                                .textFieldStyle(.roundedBorder)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TextField("Enter your email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                #if os(iOS)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                #endif
                        }

                        Button {
                            submitForm()
                            uiState = .idle
                        } label: {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(name.isEmpty || email.isEmpty)
                    }
                    .padding()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(maxWidth: 400),
                showCloseButton: true
            )
        )
    }

    func submitForm() {
        print("Name: \(name), Email: \(email)")
    }
}

// MARK: - Rive Animation Examples

/// Example 4: Rive Loading Animation
struct RiveLoadingExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Rive Loading Example")
                .font(.title)

            Button("Start Processing") {
                startProcessing()
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                autoDismissAfter: 5.0
            )
        )
    }

    func startProcessing() {
        uiState = .riveAnimation(
            riveName: "loading_spinner",
            stateMachineName: "State Machine 1",
            title: "Processing",
            message: "Please wait while we process your request..."
        )

        // Simulate processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            uiState = .success(message: "Processing complete!")
        }
    }
}

/// Example 5: Rive Success Animation
struct RiveSuccessExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Rive Success Example")
                .font(.title)

            Button("Complete Action") {
                showSuccess()
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                showCloseButton: true,
                autoDismissAfter: 3.0
            )
        )
    }

    func showSuccess() {
        uiState = .riveAnimation(
            riveName: "success_animation",
            animationName: "success",
            title: "Success!",
            message: "Your action was completed successfully"
        )
    }
}

/// Example 6: Interactive Rive Animation
struct InteractiveRiveExample: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        VStack(spacing: 20) {
            Text("Interactive Rive Example")
                .font(.title)

            Button("Show Animation") {
                uiState = .riveAnimation(
                    riveName: "interactive_animation",
                    stateMachineName: "State Machine 1",
                    title: "Interactive Demo",
                    message: "Tap the animation to interact"
                )
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                showCloseButton: true
            )
        )
    }
}

// MARK: - Combined Example

/// Example 7: Complete Flow with Multiple States
struct CompleteFlowExample: View {
    @State private var uiState: UIState = .idle
    @State private var step = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Complete Flow Example")
                .font(.title)

            Button("Start Flow") {
                startFlow()
            }
            .buttonStyle(.borderedProminent)
        }
        .uiOverlay(
            state: $uiState,
            configuration: UIOverlayConfiguration(
                style: .glass(),
                showCloseButton: step > 0
            )
        )
    }

    func startFlow() {
        step = 1
        // Step 1: Show loading
        uiState = .loading(message: "Initializing...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            step = 2
            // Step 2: Show custom form
            uiState = .custom(id: "step2") {
                VStack(spacing: 16) {
                    Text("Step 2 of 3")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Choose an Option")
                        .font(.title2)
                        .fontWeight(.bold)

                    Button("Continue") {
                        continueFlow()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }

    func continueFlow() {
        step = 3
        // Step 3: Show Rive animation
        uiState = .riveAnimation(
            riveName: "processing",
            stateMachineName: "State Machine 1",
            title: "Processing",
            message: "Finalizing your request..."
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            step = 4
            // Step 4: Show success
            uiState = .success(message: "All done! Flow completed successfully.")
        }
    }
}

// MARK: - Preview

#Preview("Rating Overlay") {
    RatingOverlayExample()
}

#Preview("Gradient Card") {
    GradientCardExample()
}

#Preview("Custom Form") {
    CustomFormExample()
}

#Preview("Rive Loading") {
    RiveLoadingExample()
}

#Preview("Rive Success") {
    RiveSuccessExample()
}

#Preview("Interactive Rive") {
    InteractiveRiveExample()
}

#Preview("Complete Flow") {
    CompleteFlowExample()
}
