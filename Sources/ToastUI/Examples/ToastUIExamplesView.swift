//
//  ToastUIExamplesView.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 25/12/25.
//

import SwiftUI

/// Comprehensive examples showcase for ToastUI
/// Demonstrates Toast Notifications, Dialogs, and UI Overlays
public struct ToastUIExamplesView: View {
    public init() {}

    public var body: some View {
        TabView {
            ToastExamplesTab()
                .tabItem {
                    Label("Toasts", systemImage: "bell.fill")
                }

            DialogExamplesTab()
                .tabItem {
                    Label("Dialogs", systemImage: "bubble.left.and.bubble.right.fill")
                }

            UIOverlayExamplesTab()
                .tabItem {
                    Label("Overlays", systemImage: "square.stack.fill")
                }
        }
    }
}

// MARK: - Toast Examples Tab

struct ToastExamplesTab: View {
    @Environment(\.toast) var toast
    @State private var showDismissButton = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Basic Toasts Section
                        ExampleSection(title: "Basic Toasts", icon: "bell.fill") {
                            VStack(spacing: 12) {
                                Button("Success Toast") {
                                    toast.success(title: "Payment successful!")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)

                                Button("Error Toast") {
                                    toast.error(title: "Network connection failed")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)

                                Button("Warning Toast") {
                                    toast.warning(title: "Low battery remaining")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)

                                Button("Info Toast") {
                                    toast.info(title: "New update available")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)
                            }
                        }
                        
                        

                        // Toast with Messages
                        ExampleSection(title: "Toast with Message", icon: "text.bubble.fill") {
                            VStack(spacing: 12) {
                                Button("Success with Details") {
                                    toast.success(
                                        title: "Order Confirmed",
                                        message: "Your order #12345 will arrive tomorrow"
                                    )
                                }
                                .buttonStyle(.borderedProminent)

                                Button("Error with Details") {
                                    toast.error(
                                        title: "Upload Failed",
                                        message: "File size exceeds 10MB limit"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)
                            }
                        }

                        // Copy to Clipboard Examples
                        ExampleSection(title: "Copy to Clipboard", icon: "doc.on.clipboard.fill") {
                            VStack(spacing: 12) {
                                Button("Short Error Code") {
                                    toast.error(
                                        title: "API Error",
                                        message: "Error code: ERR_NETWORK_TIMEOUT_5001",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)

                                Button("Long Stack Trace") {
                                    toast.error(
                                        title: "Application Crash",
                                        message: "Fatal error: Index out of range at DatabaseManager.swift:247\nStack trace: Thread 1: DatabaseManager.fetchRecords() -> QueryBuilder.execute() -> ResultSet.next()\nError code: SQLITE_ERROR (1) Database is locked",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red.opacity(0.8))

                                Button("JSON Error Response") {
                                    toast.error(
                                        title: "Server Error",
                                        message: #"{"error": "ValidationError", "message": "Invalid email format", "field": "user.email", "code": 422, "timestamp": "2024-12-25T10:30:45Z", "details": {"expected": "email", "received": "plaintext"}}"#,
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)

                                Button("API Key") {
                                    toast.info(
                                        title: "API Credentials",
                                        message: "API Key: sk_live_51MZw8xKYz9vN4pQ8L2rH3mT6fJ9kW2pR5nX1cV7bM4dS8gF3hK6jL9wQ2pE5tY8uN1zA4sD7vC3xB6nM9kH2lP4rT7yW0qF8jG5nL2vK9sH6uJ3mT8pN1dC4rY7wX0qE9kB2lF5vG8jH3nT6mP9sD2zY5uL8rK1wN4jQ7cX0vB3hG6tM9pF2sL5nJ8uY1kD4wR7qE0cT3xG6mH9jP2vL5sK8nF1yU4bN7wQ0rD3tJ6cX9mG2hL5pE8vK1sF4nY7uT0qW3jB6rM9dC2xH5lP8kG1vN4sJ7yE0tL3wF6uQ9rK2mD5nB8hX1pT4cY7jG0sL3vE6wN9kF2uH5rJ8tP1dM4xQ7yC0lB3nG6sK9vT2wF5jD8rE1uL4hN7pY0qX3mJ6tB9cG2sK5wH8nF1vP4rY7dL0jE3uT6xQ9mN2kC5bG8sW1hJ4lF7pD0vR3yE6tK9nU2jL5mX8qG1sB4wH7cN0pF3vT6rD9kY2lJ5uE8xM1nQ4tG7sL0hW3bP6jF9vK2rC5yN8dT1uG4xJ7mL0sE3qH6pW9kF2vB5nD8rY1jT4cL7uG0xN3mK6sP9hE2wF5vJ8rQ1lD4tB7yC0nG3uK6xM9sH2pL5jF8vW1rE4dT7nY0qG3bJ6kU9mC2sL5hP8xF1vN4rD7tW0jE3yK6qG9lB2uH5sT8mP1cF4nJ7vX0rL3wD6yE9kG2sN5hQ8jU1pT4bM7cF0vL3xR6nK9sJ2wE5uG8dH1tP4yB7mL0qC3vF6nX9rK2jS5hD8lW1uT4pG7yE0vN3xM6kJ9sF2rL5bH8cQ1dT4nW7uG0vP3jK6mE9yX2sL5hF8rB1wD4tN7qC0vJ3uG6xK9pL2sM5nH8yF1rE4dT7jW0bG3cP6vL9sK2uN5hQ8xF1mJ4rD7tE0yG3wB6lC9vN2sP5kH8uJ1xT4nF7rL0dY3mG6qW9sE2vB5hK8cP1jD4tN7uL0xF3rG6yM9sQ2wH5vK8nJ1pE4lT7dB0cG3xU6mF9rN2sL5hY8jW1vP4kD7tQ0nE3uG6xC9mB2sH5lF8rJ1vK4wT7yN0dP3qG6vL9xE2sM5hF8uJ1nB4rC7tD0wK3yG6pL9xN2sQ5vH8mF1jE4rT7uW0dB3cG6lK9sP2nY5hM8vF1xJ4rD7tE0wG3qL6uN9sC2bH5pK8vT1mJ4xF7rL0dY3nG6wE9sQ2uH5vB8kP1jN4cT7lF0rG3xM6yD9sL2wK5hU8vJ1nP4eE7tB0qG3cF6rN9xL2sM5hW8jD1vK4uT7yP0lG3nB6sF9rC2xH5mE8vQ1wJ4tD7kL0nY3pG6uF9sT2rB5hM8cX1vK4jE7wN0dL3yG6pQ9sF2vH5nJ8uM1rB4xT7cD0lK3wG6sE9yP2vN5hL8jF1uC4rT7qX0mG3dB6sW9kH2vL5pF8nJ1yE4rD7tU0cG3xK6mQ9sB2wL5hN8vP1jF4rT7dY0eG3uL6xC9sM2kH5vF8nJ1wB4pD7rQ0tG3lE6yK9sN2xH5uP8mF1vJ4cT7rL0dW3bG6sQ9kY2vH5nE8jF1xM4rP7uD0tL3wC6sG9yB2hK5vN8lF1jQ4rT7xE0mP3dG6uL9sW2vH5nK8cF1yJ4rB7tD0eG3xQ6pL9sM2vK5hN8uF1wJ4rC7lT0dY3bG6sE9xP2vH5mK8nF1jU4rL7tD0wG3qC6sB9yN2vH5lP8xF1mJ4rT7eK0dG3uL6sW9cQ2vN5hM8kF1jP4rB7tY0xD3lG6sE9uC2wK5vH8nF1mJ4rT7pQ0dL3yG6xB9sN2vP5hK8cF1uJ4rW7tM0eG3lQ6sD9xH2vB5nK8yF1jP4rC7uT0wG3dL6sE9mN2vQ5hF8xK1jB4rP7tY0cG3uL6sW9nM2vH5kE8lF1jD4rQ7xT0pG3yB6sC9uN2vK5hL8mF1wJ4rE7tD0xG3qP6sB9yL2vH5nK8cF1uJ4rT7mW0dG3lE6sQ9xN2vP5hM8kF1jB4rC7tY0uG3dL6sW9eH2vN5kQ8xF1jP4rM7tB0lG3yC6sE9uK2vH5nF8wJ1dP4rT7xQ0mG3lB6sD9yN2vK5hE8cF1uJ4rL7tW0pG3xM6sQ9vB2hN5kF8jD1rC4tY7eG0uL3sW6xP9mH2vK5nF8lJ1rB4qT7dG0yC3sE6uN9vL2hM5kF8xJ1wP4rD7tB0lG3cQ6sY9mK2vH5nF8jE1uR4tC7xW0dG3pL6sB9yN2vK5hQ8mF1jD4rT7uE0lG3xC6sW9nP2vH5kM8cF1jB4rY7tQ0dG3uL6sE9xN2vK5hF8wJ1mP4rC7tD0lB3yG6sQ9vH2nK5uF8xJ1eM4rP7tW0cG3dL6sB9yN2vK5hQ8mF1jE4rT7uC0xG3pL6sW9nH2vM5kF8jD1rB4tY7eG0lQ3sC6uN9vP2hK5xF8mJ1wD4rT7",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)

                                Button("Connection String") {
                                    toast.warning(
                                        title: "Database Config",
                                        message: "mongodb+srv://admin:p4ssw0rd123@cluster0.mongodb.net/production?retryWrites=true&w=majority&ssl=true&authSource=admin",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)

                                Button("Transaction ID") {
                                    toast.success(
                                        title: "Payment Complete",
                                        message: "Transaction: txn_3N2K9xL4f8mH6pQ1rY7wV5nJ9sD2uG8kF3tB6cX0lM4hT7eP9qL2vN5jR8yU1dW4sK7mG0cB3xH6fT9nL2pQ5vY8uJ1rM4kD7wE0sG3hN6cL9xF2jP5tB8vQ1uK4yR7mN0eH3lD6sW9cF2xG5jT8pL1vM4nB7rY0uK3qE6sC9hD2wF5xN8jL1tG4pM7vR0yB3cU6sH9kE2lF5nJ8xQ1dT4wP7mG0rL3vC6yN9sB2hK5uF8jD1xM4tE7pW0qG3lR6sN9vH2cF5kJ8yB1uT4rL7mD0eG3xP6sQ9wK2vN5hF8lJ1cB4rT7yM0dU3gL6sE9xH2vP5nK8mF1jC4rW7tD0qG3yB6sL9uN2vH5xK8cF1jP4rT7eM0wG3dL6sB9yQ2vN5hK8mF1uJ4rC7tX0pG3lE6sW9nH2vM5kF8jD1rB4yT7eG0qC3sU6nL9vP2hK5xF8mJ1wD4rT7",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)

                                Button("Exception Details") {
                                    toast.error(
                                        title: "Unhandled Exception",
                                        message: "System.InvalidOperationException: The operation failed because the database connection could not be established within the timeout period. This may be caused by network issues, firewall restrictions, or the database server being offline.\n\nInner Exception: System.TimeoutException: Connection attempt timed out after 30 seconds.\n\nSuggested Actions:\n1. Check network connectivity\n2. Verify firewall settings\n3. Ensure database server is running\n4. Increase connection timeout value",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red.opacity(0.6))

                                Button("Environment Config") {
                                    toast.info(
                                        title: "Debug Environment",
                                        message: "NODE_ENV=production\nDATABASE_URL=postgresql://user:pass@db.example.com:5432/mydb\nREDIS_URL=redis://cache.example.com:6379\nAPI_BASE_URL=https://api.example.com/v2\nLOG_LEVEL=debug\nMAX_CONNECTIONS=100",
                                        enableCopy: true
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.cyan)

                                Text("Tap copy icon to copy long error messages & tokens")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Glass Effect Toast
                        ExampleSection(title: "Glass Effect", icon: "sparkles") {
                            VStack(spacing: 12) {
                                Button("Glass Success") {
                                    toast.glass(title: "Beautiful glass effect", alignment: .top)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)

                                Button("Glass with Message") {
                                    toast.glass(
                                        title: "Premium Feature",
                                        message: "Enjoy the elegant glass morphism design"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple.opacity(0.8))

                                Text("iOS 26+ only, auto-fallback on older versions")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Progress Toast
                        ExampleSection(title: "Progress Indicator", icon: "arrow.triangle.2.circlepath") {
                            VStack(spacing: 12) {
                                Button("Upload Progress") {
                                    toast.progress(title: "Uploading files...", alignment: .top)
                                    showDismissButton = true

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        toast.success(title: "Upload complete!")
                                        showDismissButton = false
                                    }
                                }
                                .buttonStyle(.borderedProminent)

                                Button("Processing Data") {
                                    toast.progress(title: "Processing your request", alignment: .top)
                                    showDismissButton = true

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        toast.success(title: "Processing complete!", alignment: .top)
                                        showDismissButton = false
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.cyan)

                                Text("Progress toasts show at top with dismiss button")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Different Alignments
                        ExampleSection(title: "Toast Alignment", icon: "arrow.up.and.down") {
                            VStack(spacing: 12) {
                                Button("Top Toast") {
                                    toast.success(title: "Top aligned", alignment: .top)
                                }
                                .buttonStyle(.bordered)

                                Button("Center Toast") {
                                    toast.info(title: "Center aligned", alignment: .center)
                                }
                                .buttonStyle(.bordered)

                                Button("Bottom Toast") {
                                    toast.warning(title: "Bottom aligned", alignment: .bottom)
                                }
                                .buttonStyle(.bordered)
                            }
                        }

                        // Auto Dismiss & Manual Control
                        ExampleSection(title: "Dismiss Control", icon: "timer") {
                            VStack(spacing: 12) {
                                Button("Quick Toast (2s)") {
                                    toast.success(
                                        title: "Quick notification",
                                        message: "Automatically dismisses in 2 seconds"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                

                                Button("Long Toast (5s)") {
                                    toast.info(
                                        title: "Extended notification",
                                        message: "This stays visible for 5 seconds"
                                    )
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.indigo)

                                Button("Manual Dismiss Only") {
                                    toast.warning(
                                        title: "Important Message",
                                        message: "Tap floating button or swipe to dismiss"
                                    )
                                    
                                    showDismissButton = true
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)
                                

                                Text("Use floating button to dismiss all toasts")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Sequential Toasts
                        ExampleSection(title: "Sequential Toasts", icon: "list.number") {
                            VStack(spacing: 12) {
                                Button("Show Sequence") {
                                    showSequentialToasts()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.pink)

                                Button("Stacked Toasts") {
                                    showStackedToasts()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)

                                Text("Watch multiple toasts appear one after another")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Custom Styled Toasts
                        ExampleSection(title: "Custom Styles", icon: "paintbrush.fill") {
                            VStack(spacing: 12) {
                                Button("Minimal Toast") {
                                    toast.info(title: "Clean & Simple")
                                }
                                .buttonStyle(.bordered)

                                Button("Rich Toast") {
                                    toast.success(
                                        title: "Premium Account Activated",
                                        message: "Enjoy unlimited access to all features including cloud sync, priority support, and exclusive content"
                                    )
                                }
                                .buttonStyle(.bordered)

                                Button("Emoji Toast") {
                                    toast.success(title: "🎉 Congratulations! You won!")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 80) // Space for floating button
                }

                // Floating Dismiss Button
                if showDismissButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                toast.dismiss()
                                showDismissButton = false
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Dismiss All")
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showDismissButton)
                }
            }
            .navigationTitle("Toast Examples")
        }
    }

    private func showSequentialToasts() {
        toast.info(title: "Step 1: Starting process")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            toast.progress(title: "Step 2: Processing data")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            toast.warning(title: "Step 3: Finalizing")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            toast.success(title: "Step 4: Complete!")
        }
    }

    private func showStackedToasts() {
        toast.success(title: "First notification", alignment: .top)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            toast.info(title: "Second notification", alignment: .top)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            toast.warning(title: "Third notification", alignment: .top)
        }
    }
}

// MARK: - Dialog Examples Tab

struct DialogExamplesTab: View {
    @State private var showBasicDialog = false
    @State private var showAlertDialog = false
    @State private var showConfirmDialog = false
    @State private var showCustomDialog = false
    @State private var showLoginDialog = false
    @State private var showStepperDialog = false
    @State private var showFeedbackDialog = false
    @State private var showProfileDialog = false
    @State private var showPaymentDialog = false
    @State private var showSettingsDialog = false

    // Form states
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var currentStep = 1
    @State private var rating = 3
    @State private var feedbackText = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        #if os(iOS)
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Basic Dialogs
                    ExampleSection(title: "Basic Dialogs", icon: "square.and.pencil") {
                        VStack(spacing: 12) {
                            Button("Success Dialog") {
                                showBasicDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)

                            Button("Alert Dialog") {
                                showAlertDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)

                            Button("Confirmation Dialog") {
                                showConfirmDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }

                    // Form Dialogs
                    ExampleSection(title: "Form Dialogs", icon: "doc.text.fill") {
                        VStack(spacing: 12) {
                            Button("Add User Form") {
                                showCustomDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                            Button("Login Form") {
                                showLoginDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.indigo)

                            Button("Profile Form") {
                                showProfileDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)

                            Button("Payment Form") {
                                showPaymentDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.cyan)
                        }
                    }

                    // Advanced Dialogs
                    ExampleSection(title: "Advanced Dialogs", icon: "gearshape.2.fill") {
                        VStack(spacing: 12) {
                            Button("Stepper Dialog") {
                                currentStep = 1
                                showStepperDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.pink)

                            Button("Feedback Dialog") {
                                showFeedbackDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)

                            Button("Settings Dialog") {
                                showSettingsDialog = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.gray)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dialog Examples")
        }
        .dialog(isPresented: $showBasicDialog) {
            basicDialogContent()
        }
        .dialog(isPresented: $showAlertDialog) {
            alertDialogContent()
        }
        .dialog(isPresented: $showConfirmDialog) {
            confirmDialogContent()
        }
        .dialog(isPresented: $showCustomDialog) {
            customDialogContent()
        }
        .dialog(isPresented: $showLoginDialog) {
            loginDialogContent()
        }
        .dialog(isPresented: $showStepperDialog) {
            stepperDialogContent()
        }
        .dialog(isPresented: $showFeedbackDialog) {
            feedbackDialogContent()
        }
        .dialog(isPresented: $showProfileDialog) {
            profileDialogContent()
        }
        .dialog(isPresented: $showPaymentDialog) {
            paymentDialogContent()
        }
        .dialog(isPresented: $showSettingsDialog) {
            settingsDialogContent()
        }
        #else
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Dialog Examples")
                        .font(.headline)

                    Text("Dialogs are available on iOS only")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle("Dialog Examples")
        }
        #endif
    }

    #if os(iOS)
    private func basicDialogContent() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Success!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Your action was completed successfully")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("OK") {
                showBasicDialog = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
    }

    private func alertDialogContent() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text("Warning")
                .font(.title2)
                .fontWeight(.bold)

            Text("This action cannot be undone. Are you sure you want to continue?")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("Cancel") {
                    showAlertDialog = false
                }
                .buttonStyle(.bordered)

                Button("Continue") {
                    showAlertDialog = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
        .padding(30)
    }

    private func confirmDialogContent() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "trash.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)

            Text("Delete Item?")
                .font(.title2)
                .fontWeight(.bold)

            Text("This will permanently delete the item. This action cannot be undone.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("Cancel") {
                    showConfirmDialog = false
                }
                .buttonStyle(.bordered)

                Button("Delete") {
                    // Perform delete
                    showConfirmDialog = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        .padding(30)
    }

    private func customDialogContent() -> some View {
        VStack(spacing: 20) {
            Text("Add New User")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Enter name", text: $userName)
                    .textFieldStyle(.roundedBorder)
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    userName = ""
                    showCustomDialog = false
                }
                .buttonStyle(.bordered)

                Button("Add") {
                    // Add user
                    userName = ""
                    showCustomDialog = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(userName.isEmpty)
            }
        }
        .padding(30)
    }

    private func loginDialogContent() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.indigo)

                Text("Sign In")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter your credentials to continue")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextField("example@email.com", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    SecureField("Enter password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    email = ""
                    password = ""
                    showLoginDialog = false
                }
                .buttonStyle(.bordered)

                Button("Sign In") {
                    email = ""
                    password = ""
                    showLoginDialog = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
        .padding(30)
    }

    private func stepperDialogContent() -> some View {
        VStack(spacing: 24) {
            // Step Indicator
            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { step in
                    Circle()
                        .fill(currentStep >= step ? Color.pink : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }

            // Step Content
            VStack(spacing: 20) {
                switch currentStep {
                case 1:
                    VStack(spacing: 12) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.pink)

                        Text("Step 1: Personal Info")
                            .font(.title3)
                            .fontWeight(.bold)

                        TextField("Full Name", text: $fullName)
                            .textFieldStyle(.roundedBorder)
                    }
                case 2:
                    VStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.pink)

                        Text("Step 2: Contact Details")
                            .font(.title3)
                            .fontWeight(.bold)

                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)

                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.phonePad)
                    }
                case 3:
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.green)

                        Text("All Done!")
                            .font(.title3)
                            .fontWeight(.bold)

                        Text("Your information has been saved")
                            .foregroundStyle(.secondary)
                    }
                default:
                    EmptyView()
                }
            }

            // Navigation Buttons
            HStack(spacing: 12) {
                if currentStep > 1 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                if currentStep < 3 {
                    Button("Next") {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Finish") {
                        fullName = ""
                        email = ""
                        phoneNumber = ""
                        showStepperDialog = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding(30)
    }

    private func feedbackDialogContent() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow)

            Text("Rate Your Experience")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                // Star Rating
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 30))
                            .foregroundStyle(star <= rating ? .yellow : .gray)
                            .onTapGesture {
                                rating = star
                            }
                    }
                }

                // Feedback Text
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comments (Optional)")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextEditor(text: $feedbackText)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    rating = 3
                    feedbackText = ""
                    showFeedbackDialog = false
                }
                .buttonStyle(.bordered)

                Button("Submit") {
                    rating = 3
                    feedbackText = ""
                    showFeedbackDialog = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding(30)
    }

    private func profileDialogContent() -> some View {
        VStack(spacing: 24) {
            Text("Edit Profile")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextField("John Doe", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextField("+1 (555) 123-4567", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Address")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextField("123 Main St, City, State", text: $address)
                        .textFieldStyle(.roundedBorder)
                }
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    fullName = ""
                    phoneNumber = ""
                    address = ""
                    showProfileDialog = false
                }
                .buttonStyle(.bordered)

                Button("Save") {
                    fullName = ""
                    phoneNumber = ""
                    address = ""
                    showProfileDialog = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(30)
    }

    private func paymentDialogContent() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.cyan)

                Text("Payment Information")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter your card details")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Number")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    TextField("1234 5678 9012 3456", text: $cardNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expiry Date")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        TextField("MM/YY", text: $expiryDate)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("CVV")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        SecureField("123", text: $cvv)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                }
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    cardNumber = ""
                    expiryDate = ""
                    cvv = ""
                    showPaymentDialog = false
                }
                .buttonStyle(.bordered)

                Button("Pay Now") {
                    cardNumber = ""
                    expiryDate = ""
                    cvv = ""
                    showPaymentDialog = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .disabled(cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty)
            }
        }
        .padding(30)
    }

    private func settingsDialogContent() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.gray)

                Text("Settings")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notifications")
                            .fontWeight(.medium)
                        Text("Receive push notifications")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Toggle("", isOn: $notificationsEnabled)
                        .labelsHidden()
                }

                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dark Mode")
                            .fontWeight(.medium)
                        Text("Use dark appearance")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Toggle("", isOn: $darkModeEnabled)
                        .labelsHidden()
                }
            }

            Button("Done") {
                showSettingsDialog = false
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
        }
        .padding(30)
    }
    #endif
}

// MARK: - UI Overlay Examples Tab

struct UIOverlayExamplesTab: View {
    @State private var uiState: UIState = .idle
    @State private var currentConfiguration: UIOverlayConfiguration = .glass
    @Environment(\.toast) var toast

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Loading States
                    ExampleSection(title: "Loading States", icon: "arrow.triangle.2.circlepath") {
                        VStack(spacing: 12) {
                            Button("Simple Loading") {
                                uiState = .loading(message: "Loading...")
                                dismissAfter(2)
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Processing Data") {
                                uiState = .loading(message: "Processing your request...")
                                dismissAfter(3)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                            Button("Custom Loader") {
                                uiState = .loading(message: "Uploading files") {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .scaleEffect(1.5)
                                        .tint(.purple)
                                }
                                dismissAfter(2.5)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)

                            Button("Long Operation") {
                                uiState = .loading(message: "This may take a while...")
                                dismissAfter(4)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        }
                    }

                    // Empty States
                    ExampleSection(title: "Empty States", icon: "tray") {
                        VStack(spacing: 12) {
                            Button("No Items") {
                                currentConfiguration = .withClose
                                uiState = .empty(message: "No items found")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.gray)

                            Button("No Results") {
                                currentConfiguration = .withClose
                                uiState = .empty(message: "No search results")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.gray.opacity(0.8))

                            Button("Empty Inbox") {
                                currentConfiguration = .withClose
                                uiState = .empty(message: "Your inbox is empty") {
                                    Image(systemName: "envelope.open")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.blue)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                            Button("No Favorites") {
                                currentConfiguration = .withClose
                                uiState = .empty(message: "No favorites yet") {
                                    Image(systemName: "heart.slash")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.red)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)

                            Text("Empty states show with close button")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Success States
                    ExampleSection(title: "Success States", icon: "checkmark.circle.fill") {
                        VStack(spacing: 12) {
                            Button("Operation Complete") {
                                uiState = .success(message: "Operation completed successfully!")
                                dismissAfter(2)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)

                            Button("Data Saved") {
                                uiState = .success(message: "Your changes have been saved")
                                dismissAfter(2.5)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green.opacity(0.8))

                            Button("Upload Complete") {
                                uiState = .success(message: "File uploaded successfully")
                                dismissAfter(2)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.mint)

                            Button("Payment Successful") {
                                uiState = .success(message: "Payment processed successfully")
                                dismissAfter(3)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.teal)
                        }
                    }

                    // Failure States
                    ExampleSection(title: "Failure States", icon: "exclamationmark.triangle.fill") {
                        VStack(spacing: 12) {
                            Button("Network Error") {
                                currentConfiguration = .withClose
                                uiState = .failure(message: "Network connection failed")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)

                            Button("Server Error") {
                                currentConfiguration = .withClose
                                uiState = .failure(message: "Server error occurred. Please try again.")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red.opacity(0.8))

                            Button("Authentication Failed") {
                                currentConfiguration = .withClose
                                uiState = .failure(message: "Authentication failed. Please login again.")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)

                            Button("Permission Denied") {
                                currentConfiguration = .withClose
                                uiState = .failure(message: "You don't have permission to perform this action")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.pink)

                            Text("Failure states show with close button and retry option")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Glass Intensity Examples
                    ExampleSection(title: "Glass Intensities", icon: "circle.hexagongrid.fill") {
                        VStack(spacing: 12) {
                            Button("Ultra Thin (Lightest)") {
                                showGlassOverlay(intensity: .ultraThin)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple.opacity(0.6))

                            Button("Thin") {
                                showGlassOverlay(intensity: .thin)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple.opacity(0.7))

                            Button("Regular") {
                                showGlassOverlay(intensity: .regular)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple.opacity(0.8))

                            Button("Thick") {
                                showGlassOverlay(intensity: .thick)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple.opacity(0.9))

                            Button("Ultra Thick (Heaviest)") {
                                showGlassOverlay(intensity: .ultraThick)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)
                        }
                    }

                    // Custom Styled Overlays
                    ExampleSection(title: "Custom Styles", icon: "paintbrush.fill") {
                        VStack(spacing: 12) {
                            Button("Dark Theme") {
                                showDarkOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)

                            Button("Light Theme") {
                                showLightOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)

                            Button("Colorful Overlay") {
                                showColorfulOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.indigo)

                            Button("Gradient Background") {
                                showGradientOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.pink)

                            Button("Minimal Style") {
                                showMinimalOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.gray)
                        }
                    }

                    // Custom Content Overlays
                    ExampleSection(title: "Custom Content", icon: "square.stack.3d.up.fill") {
                        VStack(spacing: 12) {
                            Button("Welcome Message") {
                                showWelcomeOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                            Button("Achievement Unlocked") {
                                showAchievementOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.yellow)

                            Button("Rating Prompt") {
                                showRatingOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)

                            Button("Countdown Timer") {
                                showCountdownOverlay()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }

                    // Async Operations
                    ExampleSection(title: "Async Operations", icon: "network") {
                        VStack(spacing: 12) {
                            Button("Simulate API Call") {
                                Task {
                                    await simulateAsyncOperation()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.cyan)

                            Button("Fetch User Data") {
                                Task {
                                    await fetchUserData()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                            Button("Upload File") {
                                Task {
                                    await uploadFile()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)

                            Button("Delete Account") {
                                Task {
                                    await deleteAccount()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("UI Overlay Examples")
        }
        .uiOverlay(
            state: $uiState,
            configuration: currentConfiguration,
            onRetry: {
                // Retry logic
                await simulateAsyncOperation()
            }
        )
    }

    // MARK: - Helper Methods

    private func dismissAfter(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            uiState = .idle
        }
    }

    private func showGlassOverlay(intensity: GlassIntensity = .ultraThin) {
        // Set the glass configuration with specified intensity
        currentConfiguration = UIOverlayConfiguration.glass(intensity: intensity)

        // Create custom state with glass effect configuration
        uiState = .custom(id: "glass-\(intensity)") {
            VStack(spacing: 16) {
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)

                Text("Glass Effect")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(intensityDescription(intensity))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        dismissAfter(3)
    }

    private func intensityDescription(_ intensity: GlassIntensity) -> String {
        switch intensity {
        case .ultraThin:
            return "Ultra Thin - Lightest blur effect"
        case .thin:
            return "Thin - Light blur effect"
        case .regular:
            return "Regular - Medium blur effect"
        case .thick:
            return "Thick - Heavy blur effect"
        case .ultraThick:
            return "Ultra Thick - Heaviest blur effect"
        }
    }

    private func showDarkOverlay() {
        uiState = .success(message: "Dark themed overlay")
        dismissAfter(2)
    }

    private func showCustomColorOverlay() {
        uiState = .custom(id: "custom") {
            VStack(spacing: 16) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)

                Text("Custom Overlay")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("You can create any custom content!")
                    .foregroundStyle(.secondary)

                Button("Dismiss") {
                    uiState = .idle
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        // Don't auto-dismiss - has dismiss button
    }

    private func simulateAsyncOperation() async {
        // Show loading
        uiState = .loading(message: "Fetching data...")

        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        // Random success or failure
        if Bool.random() {
            uiState = .success(message: "Data loaded successfully!")

            // Auto dismiss and show toast
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                uiState = .idle
                toast.success(title: "API call completed")
            }
        } else {
            uiState = .failure(message: "Failed to fetch data. Tap retry.")
        }
    }

    private func showLightOverlay() {
        currentConfiguration = .init(
            style: .solid(backgroundColor: .white, opacity: 1.0),
            titleStyle: TextStyleConfiguration(color: .black, font: .title2, fontWeight: .bold),
            messageStyle: TextStyleConfiguration(color: .gray, font: .subheadline, fontWeight: .regular)
        )
        uiState = .success(message: "Light theme overlay")
        dismissAfter(2.5)
    }

    private func showColorfulOverlay() {
        currentConfiguration = .init(
            style: .solid(backgroundColor: .indigo, opacity: 0.95),
            titleStyle: TextStyleConfiguration(color: .white, font: .title2, fontWeight: .bold),
            messageStyle: TextStyleConfiguration(color: .white.opacity(0.9), font: .subheadline, fontWeight: .regular)
        )
        uiState = .success(message: "Colorful overlay design")
        dismissAfter(2.5)
    }

    private func showGradientOverlay() {
        currentConfiguration = .init(
            style: .solid(backgroundColor: .pink, opacity: 0.9),
            titleStyle: TextStyleConfiguration(color: .white, font: .title2, fontWeight: .bold),
            messageStyle: TextStyleConfiguration(color: .white.opacity(0.8), font: .body, fontWeight: .medium)
        )
        uiState = .success(message: "Beautiful gradient styling")
        dismissAfter(2.5)
    }

    private func showMinimalOverlay() {
        currentConfiguration = .init(
            style: .solid(backgroundColor: .white, opacity: 1.0, backdropOpacity: 0.1),
            titleStyle: TextStyleConfiguration(color: .black, font: .headline, fontWeight: .semibold),
            messageStyle: TextStyleConfiguration(color: .gray, font: .caption, fontWeight: .regular)
        )
        uiState = .success(message: "Minimal clean design")
        dismissAfter(2.5)
    }

    private func showWelcomeOverlay() {
        currentConfiguration = .glass
        uiState = .custom(id: "welcome") {
            VStack(spacing: 20) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.yellow)

                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Thank you for using our app")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Get Started") {
                    uiState = .idle
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(30)
        }
        // Don't auto-dismiss - user must interact with button
    }

    private func showAchievementOverlay() {
        currentConfiguration = .glass(intensity: .regular)
        uiState = .custom(id: "achievement") {
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.yellow)

                Text("Achievement Unlocked!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("You've completed 100 tasks")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }

                Button("Awesome!") {
                    uiState = .idle
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
            }
            .padding(30)
        }
        // Don't auto-dismiss - user must acknowledge achievement
    }

    private func showRatingOverlay() {
        currentConfiguration = .glass(intensity: .thin)
        uiState = .custom(id: "rating") {
            VStack(spacing: 24) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)

                Text("Enjoying the app?")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Rate us on the App Store")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Button("Maybe Later") {
                        uiState = .idle
                    }
                    .buttonStyle(.bordered)

                    Button("Rate Now") {
                        uiState = .idle
                        toast.success(title: "Thank you!")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
            }
            .padding(30)
        }
        // Don't auto-dismiss - user must make a choice
    }

    private func showCountdownOverlay() {
        currentConfiguration = .glass(intensity: .thick)
        uiState = .custom(id: "countdown") {
            VStack(spacing: 20) {
                Image(systemName: "timer")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)

                Text("Limited Time Offer!")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("3:00")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(.red)

                Text("Don't miss out on this exclusive deal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Claim Offer") {
                    uiState = .idle
                    toast.success(title: "Offer claimed!")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding(30)
        }
        // Don't auto-dismiss - requires user action
    }

    private func fetchUserData() async {
        currentConfiguration = .glass(intensity: .thin)
        uiState = .loading(message: "Fetching user profile...")

        try? await Task.sleep(nanoseconds: 1_500_000_000)

        uiState = .success(message: "Profile loaded successfully")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            uiState = .idle
        }
    }

    private func uploadFile() async {
        currentConfiguration = .glass(intensity: .regular)
        uiState = .loading(message: "Uploading file...")

        try? await Task.sleep(nanoseconds: 2_500_000_000)

        if Bool.random() {
            uiState = .success(message: "File uploaded successfully")
            dismissAfter(2)
        } else {
            uiState = .failure(message: "Upload failed. Check your connection.")
        }
    }

    private func deleteAccount() async {
        currentConfiguration = .init(
            style: .solid(backgroundColor: .red.opacity(0.1), opacity: 1.0),
            titleStyle: TextStyleConfiguration(color: .red, font: .title2, fontWeight: .bold),
            messageStyle: TextStyleConfiguration(color: .red.opacity(0.8), font: .subheadline, fontWeight: .regular)
        )

        uiState = .loading(message: "Deleting account...")

        try? await Task.sleep(nanoseconds: 2_000_000_000)

        uiState = .success(message: "Account deleted successfully")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiState = .idle
        }
    }
}

// MARK: - Helper Views

struct ExampleSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.headline)
            }

            VStack(spacing: 12) {
                content
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    ToastUIExamplesView()
        .setupToastUI()
}
