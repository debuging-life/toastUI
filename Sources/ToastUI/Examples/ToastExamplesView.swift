//
//  SwiftUIView.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

struct ToastExamplesView: View {
    @Environment(\.toast) var toast
    @StateObject private var viewModel = ExampleViewModel()
    
    var body: some View {
        NavigationView {
            List {
                basicToastsSection
                titleOnlySection
                stackingSection
                alignmentSection
                customColorsSection
                customIconsSection
                customStylingSection
                progressToastsSection
                closeButtonSection
                durationSection
                filoSection
                viewModelSection
                realWorldSection
                dismissSection
            }
            .navigationTitle("Toast Examples")
        }
    }
    
    // MARK: - Basic Toasts
    
    private var basicToastsSection: some View {
        Section {
            Button("Success Toast") {
                toast.success(
                    title: "Success!",
                    message: "Your operation completed successfully"
                )
            }
            
            Button("Error Toast") {
                toast.error(
                    title: "Error Occurred",
                    message: "Failed to connect to the server"
                )
            }
            
            Button("Warning Toast") {
                toast.warning(
                    title: "Warning",
                    message: "Your session will expire in 5 minutes"
                )
            }
            
            Button("Info Toast") {
                toast.info(
                    title: "Did You Know?",
                    message: "You can customize every aspect of toasts"
                )
            }
        } header: {
            Text("Basic Toast Types")
        } footer: {
            Text("Standard toast types with default colors and icons")
        }
    }
    
    // MARK: - Title Only
    
    private var titleOnlySection: some View {
        Section {
            Button("Quick Success") {
                toast.success(title: "Saved!")
            }
            
            Button("Quick Error") {
                toast.error(title: "Failed to load")
            }
            
            Button("Quick Warning") {
                toast.warning(title: "Low battery")
            }
            
            Button("Quick Info") {
                toast.info(title: "Settings updated")
            }
        } header: {
            Text("Title-Only Toasts")
        } footer: {
            Text("Toasts can have just a title without a message for quick feedback")
        }
    }
    
    // MARK: - Stacking
    
    private var stackingSection: some View {
        Section {
            Button("Add Single Toast") {
                toast.success(
                    title: "Single Toast",
                    message: "Watch it slide in",
                    duration: 5.0
                )
            }
            
            Button("Stack 3 Toasts") {
                for i in 1...3 {
                    toast.success(
                        title: "Toast #\(i)",
                        message: "Stacking beautifully",
                        duration: 8.0
                    )
                }
            }
            
            Button("Stack 5 Toasts") {
                for i in 1...5 {
                    toast.info(
                        title: "Toast #\(i)",
                        message: "Up to 3 visible at once",
                        duration: 10.0
                    )
                }
            }
            
            Button("Rapid Stack (10 toasts)") {
                for i in 1...10 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                        toast.success(
                            title: "Toast #\(i)",
                            message: "Smooth stacking animation",
                            duration: 15.0
                        )
                    }
                }
            }
            
            Button("Mixed Types Stack") {
                toast.success(title: "Success 1", duration: 10.0)
                toast.error(title: "Error 2", duration: 10.0)
                toast.warning(title: "Warning 3", duration: 10.0)
                toast.info(title: "Info 4", duration: 10.0)
            }
        } header: {
            Text("Multiple Toasts & Stacking")
        } footer: {
            Text("Toasts stack with visual depth effect. Up to 3 visible at once (100%, 95%, 90% scale)")
        }
    }
    
    // MARK: - Alignment
    
    private var alignmentSection: some View {
        Section {
            Button("Top Alignment (Default)") {
                toast.success(
                    title: "Top Toast",
                    message: "Appears at the top of the screen",
                    duration: 4.0, alignment: .top
                )
            }
            
            Button("Center Alignment") {
                toast.warning(
                    title: "Center Toast",
                    message: "Appears in the center of the screen",
                    duration: 4.0, alignment: .center
                )
            }
            
            Button("Bottom Alignment") {
                toast.info(
                    title: "Bottom Toast",
                    message: "Appears at the bottom of the screen",
                    duration: 4.0, alignment: .bottom
                )
            }
            
            Button("All Alignments at Once") {
                toast.success(title: "Top Toast", message: "At the top", duration: 6.0, alignment: .top)
                toast.warning(title: "Center Toast", message: "In the center", duration: 6.0, alignment: .center)
                toast.error(title: "Bottom Toast", message: "At the bottom", duration: 6.0, alignment: .bottom)
            }
            
            Button("Stack at Bottom") {
                for i in 1...3 {
                    toast.info(
                        title: "Bottom Toast #\(i)",
                        duration: 8.0, alignment: .bottom
                    )
                }
            }
        } header: {
            Text("Toast Alignment")
        } footer: {
            Text("Toasts can appear at top, center, or bottom. Each alignment has independent stacking")
        }
    }
    
    // MARK: - Custom Colors
    
    private var customColorsSection: some View {
        Section {
            Button("Pink Background") {
                toast.success(
                    title: "Custom Pink",
                    message: "Using custom background color",
                    backgroundColor: .pink
                )
            }
            
            Button("Teal Background") {
                toast.info(
                    title: "Teal Color",
                    message: "Soothing teal background",
                    backgroundColor: .teal
                )
            }
            
            Button("Indigo Background") {
                toast.warning(
                    title: "Indigo Alert",
                    message: "Custom indigo color",
                    backgroundColor: .indigo
                )
            }
            
            Button("Brand Color (Hex)") {
                toast.success(
                    title: "Brand Toast",
                    message: "Using hex color #6366f1",
                    backgroundColor: Color(hex: "#6366f1")
                )
            }
            
            Button("Semi-Transparent") {
                toast.info(
                    title: "Transparent",
                    message: "70% opacity background",
                    backgroundColor: .purple.opacity(0.7)
                )
            }
            
            Button("Dark Theme") {
                toast.error(
                    title: "Dark Mode",
                    message: "Custom dark background",
                    backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15)
                )
            }
            
            Button("Gradient Effect") {
                toast.success(
                    title: "Gradient-like",
                    message: "Using opacity for depth",
                    backgroundColor: .blue.opacity(0.8)
                )
            }
        } header: {
            Text("Custom Background Colors")
        } footer: {
            Text("Override default colors with any SwiftUI Color, including hex values and opacity")
        }
    }
    
    // MARK: - Custom Icons
    
    private var customIconsSection: some View {
        Section {
            Button("Heart Icon") {
                toast.present(
                    title: "Liked!",
                    message: "Added to favorites",
                    type: .success,
                    duration: 4.0
                ) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            Button("Envelope Icon") {
                toast.present(
                    title: "New Message",
                    message: "You have 3 unread messages",
                    type: .info,
                    duration: 4.0
                ) {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            Button("Badge Icon") {
                toast.present(
                    title: "Achievement Unlocked!",
                    message: "You've completed 10 tasks",
                    type: .success,
                    duration: 4.0, alignment: .center
                ) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            
            Button("Flame Icon") {
                toast.present(
                    title: "Streak: 7 Days!",
                    message: "Keep it up!",
                    type: .warning,
                    duration: 4.0, backgroundColor: .orange
                ) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            Button("Download Icon") {
                toast.present(
                    title: "Download Complete",
                    message: "File saved to downloads",
                    type: .success,
                    duration: 4.0
                ) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            Button("Custom View Icon") {
                toast.present(
                    title: "Premium Feature",
                    message: "Upgrade to unlock",
                    type: .info,
                    duration: 4.0, backgroundColor: .purple
                ) {
                    HStack(spacing: 2) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                        Image(systemName: "crown.fill")
                            .font(.title3)
                        Image(systemName: "sparkles")
                            .font(.caption)
                    }
                    .foregroundStyle(.yellow)
                }
            }
        } header: {
            Text("Custom Icons")
        } footer: {
            Text("Use any SwiftUI View as a custom icon, including SF Symbols, images, or complex views")
        }
    }
    
    // MARK: - Custom Styling
    
    private var customStylingSection: some View {
        Section {
            Button("Default Style") {
                toast.success(
                    title: "Default Style",
                    message: "Standard configuration",
                    configuration: .default
                )
            }
            
            Button("Compact Style") {
                toast.info(
                    title: "Compact",
                    message: "Smaller padding and shadow",
                    configuration: .compact
                )
            }
            
            Button("Rounded Style") {
                toast.warning(
                    title: "Very Rounded",
                    message: "Large corner radius",
                    configuration: .rounded
                )
            }
            
            Button("Minimal Style") {
                toast.error(
                    title: "Minimal",
                    message: "Clean and simple",
                    configuration: .minimal
                )
            }
            
            Button("Custom Configuration") {
                let customConfig = ToastConfiguration(
                    cornerRadius: 25,
                    shadowRadius: 20,
                    shadowColor: .purple.opacity(0.3),
                    shadowX: 0,
                    shadowY: 10,
                    horizontalPadding: 24,
                    verticalPadding: 20
                )
                
                toast.success(
                    title: "Fully Custom",
                    message: "Custom corner radius, shadow, and padding",
                    backgroundColor: .purple,
                    configuration: customConfig
                )
            }
            
            Button("Ultimate Toast") {
                let config = ToastConfiguration(
                    cornerRadius: 30,
                    shadowRadius: 25,
                    shadowColor: .pink.opacity(0.4),
                    shadowX: 0,
                    shadowY: 15,
                    horizontalPadding: 28,
                    verticalPadding: 24
                )
                
                toast.present(
                    title: "Everything Custom",
                    message: "Style + Color + Icon + Alignment",
                    type: .success,
                    duration: 5.0,
                    alignment: .center,
                    backgroundColor: Color(hex: "#FF6B6B"),
                    configuration: config
                ) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
            }
        } header: {
            Text("Custom Styling & Configuration")
        } footer: {
            Text("Use pre-defined styles or create custom configurations with corner radius, shadows, and padding")
        }
    }
    
    // MARK: - Progress Toasts
    
    private var progressToastsSection: some View {
        Section {
            Button("Simple Progress") {
                toast.progress(title: "Loading...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss()
                    toast.success(title: "Complete!")
                }
            }
            
            Button("Progress with Updates") {
                Task {
                    toast.progress(title: "Processing 0%")
                    
                    for i in 1...5 {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        toast.progress(title: "Processing \(i * 20)%")
                    }
                    
                    toast.dismiss()
                    toast.success(title: "Processing Complete!")
                }
            }
            
            Button("Bottom Progress") {
                toast.progress(
                    title: "Uploading...",
                    alignment: .bottom,
                    configuration: .rounded
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    toast.dismiss()
                    toast.success(
                        title: "Upload Complete",
                        alignment: .bottom,
                        configuration: .rounded
                    )
                }
            }
            
            Button("Custom Progress") {
                let config = ToastConfiguration(
                    cornerRadius: 20,
                    shadowRadius: 15,
                    shadowColor: .indigo.opacity(0.3),
                    shadowY: 8,
                    horizontalPadding: 20,
                    verticalPadding: 18
                )
                
                toast.progress(
                    title: "Custom Loading...",
                    backgroundColor: .indigo,
                    configuration: config
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    toast.dismiss()
                }
            }
            
            Button("Replace Progress") {
                toast.progress(title: "First operation...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    toast.progress(title: "Second operation...")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss()
                }
            }
            
            Button("Progress with Error Below") {
                toast.error(
                    title: "Connection Error",
                    message: "This will stay after progress dismisses",
                    duration: 8.0
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    toast.progress(title: "Retrying...")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss() // Dismiss progress, error timer restarts
                }
            }
        } header: {
            Text("Progress Toasts")
        } footer: {
            Text("Progress toasts: (1) Single per alignment, (2) No close button, (3) Must dismiss manually, (4) Don't stack")
        }
    }
    
    // MARK: - Close Button
    
    private var closeButtonSection: some View {
        Section {
            Button("With Close Button (Default)") {
                toast.success(
                    title: "Dismissible",
                    message: "Click X to close anytime",
                    duration: 10.0,
                    showCloseButton: true
                )
            }
            
            Button("Without Close Button") {
                toast.info(
                    title: "Auto-dismiss Only",
                    message: "No close button - waits for timer",
                    duration: 5.0,
                    showCloseButton: false
                )
            }
            
            Button("Long Toast with Close") {
                toast.warning(
                    title: "Read Carefully",
                    message: "This toast stays for 20 seconds. Click X to dismiss early.",
                    duration: 20.0,
                    showCloseButton: true
                )
            }
            
            Button("Stack - Manual Close Test") {
                for i in 1...5 {
                    toast.success(
                        title: "Toast #\(i)",
                        message: "Click X on any toast to close it",
                        duration: 30.0,
                        showCloseButton: true
                    )
                }
            }
        } header: {
            Text("Close Button Control")
        } footer: {
            Text("Show or hide the close button. Progress toasts never have close buttons.")
        }
    }
    
    // MARK: - Duration
    
    private var durationSection: some View {
        Section {
            Button("Quick (1 second)") {
                toast.success(
                    title: "Quick!",
                    message: "Dismisses in 1 second",
                    duration: 1.0
                )
            }
            
            Button("Short (2 seconds)") {
                toast.info(
                    title: "Short",
                    message: "Dismisses in 2 seconds",
                    duration: 2.0
                )
            }
            
            Button("Normal (3 seconds, default)") {
                toast.success(
                    title: "Normal",
                    message: "Default 3 second duration"
                )
            }
            
            Button("Long (10 seconds)") {
                toast.warning(
                    title: "Long Duration",
                    message: "Stays for 10 seconds",
                    duration: 10.0
                )
            }
            
            Button("Very Long (30 seconds)") {
                toast.error(
                    title: "Very Long",
                    message: "Stays for 30 seconds (click X to dismiss early)",
                    duration: 30.0
                )
            }
            
            Button("Mixed Durations") {
                toast.success(title: "5 seconds", duration: 5.0)
                toast.info(title: "3 seconds", duration: 3.0)
                toast.warning(title: "7 seconds", duration: 7.0)
            }
        } header: {
            Text("Custom Duration")
        } footer: {
            Text("Set any duration in seconds. Default is 3.0 seconds. Progress toasts ignore duration.")
        }
    }
    
    // MARK: - FILO Behavior
    
    private var filoSection: some View {
        Section {
            Button("FILO Test (5s, 3s, 4s)") {
                toast.success(title: "First (5s)", message: "Added first", duration: 5.0)
                toast.info(title: "Second (3s)", message: "Added second", duration: 3.0)
                toast.warning(title: "Third (4s)", message: "Added third", duration: 4.0)
            }
            
            Button("Watch FILO Order") {
                toast.success(title: "1st - Stays longest", duration: 8.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    toast.info(title: "2nd - Middle", duration: 5.0)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    toast.warning(title: "3rd - Dismisses first", duration: 3.0)
                }
            }
            
            Button("Rapid FILO") {
                for i in 1...5 {
                    let duration = Double(6 - i)
                    toast.success(
                        title: "Toast #\(i)",
                        message: "Duration: \(Int(duration))s",
                        duration: duration
                    )
                }
            }
        } header: {
            Text("FILO Behavior (First In, Last Out)")
        } footer: {
            Text("Newest toast dismisses first, then next newest, etc. Watch the order carefully!")
        }
    }
    
    // MARK: - ViewModel Integration
    
    private var viewModelSection: some View {
        Section {
            Button("Fetch Data (Success)") {
                Task {
                    await viewModel.fetchData(toast: toast, shouldFail: false)
                }
            }
            
            Button("Fetch Data (Error)") {
                Task {
                    await viewModel.fetchData(toast: toast, shouldFail: true)
                }
            }
            
            Button("Upload File") {
                Task {
                    await viewModel.uploadFile(toast: toast)
                }
            }
            
            Button("Retry Operation") {
                Task {
                    await viewModel.retryOperation(toast: toast)
                }
            }
            
            Button("Batch Process") {
                Task {
                    await viewModel.batchProcess(toast: toast)
                }
            }
        } header: {
            Text("ViewModel Integration")
        } footer: {
            Text("Examples of using ToastManager in ViewModels for async operations")
        }
    }
    
    // MARK: - Real World Examples
    
    private var realWorldSection: some View {
        Section {
            Button("Form Validation") {
                // Simulate form validation
                toast.warning(
                    title: "Email Required",
                    message: "Please enter your email address"
                )
            }
            
            Button("Network Error") {
                toast.error(
                    title: "Connection Failed",
                    message: "Unable to reach the server. Please check your internet connection.",
                    duration: 5.0
                )
            }
            
            Button("Save Success") {
                toast.success(
                    title: "Changes Saved",
                    message: "Your preferences have been updated"
                )
            }
            
            Button("Copy to Clipboard") {
                toast.success(
                    title: "Copied!",
                    duration: 2.0,
                    showCloseButton: false
                )
            }
            
            Button("Low Battery Warning") {
                toast.warning(
                    title: "Low Battery",
                    message: "20% battery remaining",
                    duration: 5.0, alignment: .bottom
                )
            }
            
            Button("New Message Notification") {
                toast.present(
                    title: "Sarah messaged you",
                    message: "Hey! Are we still meeting at 3?",
                    type: .info,
                    duration: 6.0
                ) {
                    Image(systemName: "message.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            Button("Update Available") {
                toast.info(
                    title: "Update Available",
                    message: "Version 2.0 is ready to install",
                    duration: 8.0,
                    alignment: .bottom
                )
            }
        } header: {
            Text("Real-World Use Cases")
        } footer: {
            Text("Common scenarios showing practical toast usage patterns")
        }
    }
    
    // MARK: - Dismiss
    
    private var dismissSection: some View {
        Section {
            Button("Dismiss Topmost Toast") {
                toast.dismiss()
            }
            .foregroundStyle(.orange)
            
            Button("Dismiss All Toasts") {
                toast.dismissAll()
            }
            .foregroundStyle(.red)
        } header: {
            Text("Manual Dismiss")
        } footer: {
            Text("Manually dismiss toasts without waiting for timers")
        }
    }
}

// MARK: - Example ViewModel

@MainActor
class ExampleViewModel: ObservableObject {
    
    func fetchData(toast: ToastManager, shouldFail: Bool) async {
        toast.progress(title: "Fetching data...", alignment: .bottom)
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            if shouldFail {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network timeout"])
            }
            
            toast.success(
                title: "Data Loaded",
                message: "Successfully loaded 42 items",
                alignment: .bottom
            )
        } catch {
            toast.error(
                title: "Load Failed",
                message: error.localizedDescription,
                duration: 5.0, alignment: .bottom
            )
        }
    }
    
    func uploadFile(toast: ToastManager) async {
        toast.progress(
            title: "Uploading file...",
            alignment: .bottom,
            configuration: .rounded
        )
        
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        toast.success(
            title: "Upload Complete",
            message: "File uploaded successfully",
            alignment: .bottom,
            configuration: .rounded
        )
    }
    
    func retryOperation(toast: ToastManager) async {
        var retries = 0
        let maxRetries = 3
        
        toast.progress(title: "Attempting connection...")
        
        while retries < maxRetries {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            retries += 1
            
            if retries < maxRetries {
                toast.warning(
                    title: "Retrying...",
                    message: "Attempt \(retries) of \(maxRetries)"
                )
            }
        }
        
        toast.error(
            title: "Connection Failed",
            message: "Maximum retries reached",
            duration: 5.0
        )
    }
    
    func batchProcess(toast: ToastManager) async {
        let items = 5
        
        for i in 1...items {
            toast.progress(title: "Processing \(i)/\(items)...")
            try? await Task.sleep(nanoseconds: 800_000_000)
        }
        
        toast.success(
            title: "Batch Complete",
            message: "Processed \(items) items"
        )
    }
}


#Preview {
    ToastExamplesView()
}
