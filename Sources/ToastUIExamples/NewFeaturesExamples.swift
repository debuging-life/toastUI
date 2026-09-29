//
//  NewFeaturesExamples.swift
//  ToastUIExamples
//

import SwiftUI
import ToastUI

/// Everything added in 3.4 and 3.5: stacks you can expand, actions, grouping,
/// sticky toasts, theming, async dialogs and the loading helper.
public struct NewFeaturesExamplesView: View {
    @Environment(\.toast) private var toast
    @State private var lastAnswer: String = "—"

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Stacks") {
                    Button("Show three toasts, then tap the stack") {
                        toast.error(title: "Upload failed", message: "Tap the stack to read them all.")
                        toast.warning(title: "GPS signal weak")
                        toast.info(title: "Synced 3 runs")
                    }
                    Button("Fill the stack (7 toasts)") {
                        for index in 1...7 {
                            toast.info(title: "Toast \(index)", duration: 30)
                        }
                    }
                }

                Section("Actions") {
                    Button("Undo, with a countdown") {
                        toast.present(
                            ToastMessage(
                                title: "Activity deleted",
                                type: .info,
                                duration: 5,
                                action: ToastAction(title: "Undo") { toast.success(title: "Restored") }
                            )
                        )
                    }
                    Button("Tap the toast itself") {
                        toast.present(
                            ToastMessage(title: "Run synced", type: .success,
                                         onTap: { toast.info(title: "Opened the run") })
                        )
                    }
                }

                Section("Grouping and sticky") {
                    Button("Fire the same event five times") {
                        for index in 1...5 {
                            toast.present(
                                ToastMessage(title: "GPS signal lost (\(index))",
                                             type: .warning, groupID: "gps")
                            )
                        }
                    }
                    Button("Sticky offline banner") {
                        toast.present(ToastMessage(title: "You're offline", type: .warning, isSticky: true))
                    }
                }

                Section("Loading") {
                    Button("Determinate, cancellable") {
                        Task {
                            try? await toast.withLoading("Uploading run", determinate: true,
                                                         cancellable: true, errorTitle: "Upload failed") { report in
                                for step in 1...20 {
                                    try await Task.sleep(for: .milliseconds(120))
                                    await MainActor.run { report(Double(step) / 20) }
                                }
                            }
                        }
                    }
                }

                Section("Dialogs") {
                    Button("Ask, and await the answer") {
                        Task {
                            let confirmed = await toast.confirm(
                                title: "Delete activity?",
                                message: "This can't be undone.",
                                confirm: "Delete",
                                destructive: true
                            )
                            lastAnswer = confirmed ? "Deleted" : "Cancelled"
                        }
                    }
                    LabeledContent("Last answer", value: lastAnswer)
                }

                Section("Theme") {
                    Button("Lime success, rounded") {
                        ToastManager.shared.theme.colors[.success] = Color(red: 0.65, green: 0.83, blue: 0.17)
                        ToastManager.shared.theme.toast = .rounded
                        toast.success(title: "Themed toast")
                    }
                    Button("Back to defaults") {
                        ToastManager.shared.theme = .default
                        toast.info(title: "Default theme")
                    }
                }
            }
            .navigationTitle("What's new")
        }
    }
}
