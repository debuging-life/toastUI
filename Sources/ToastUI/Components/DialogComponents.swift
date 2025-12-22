//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 22/12/25.
//


import SwiftUI

// MARK: - Alert Dialog
public struct AlertDialog: View {
    let title: String
    let message: String
    let primaryButton: DialogButton
    let secondaryButton: DialogButton?
    
    public init(
        title: String,
        message: String,
        primaryButton: DialogButton,
        secondaryButton: DialogButton? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            HStack(spacing: 12) {
                if let secondaryButton = secondaryButton {
                    Button(action: secondaryButton.action) {
                        Text(secondaryButton.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                
                Button(action: primaryButton.action) {
                    Text(primaryButton.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryButton.style.color)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}

// MARK: - Confirmation Dialog
public struct ConfirmationDialog: View {
    let title: String
    let message: String
    let destructiveAction: String
    let cancelAction: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    public init(
        title: String,
        message: String,
        destructiveAction: String = "Delete",
        cancelAction: String = "Cancel",
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.destructiveAction = destructiveAction
        self.cancelAction = cancelAction
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.red)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text(cancelAction)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                
                Button(action: onConfirm) {
                    Text(destructiveAction)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
}

// MARK: - Dialog Button
public struct DialogButton {
    public let title: String
    public let style: DialogButtonStyle
    public let action: () -> Void
    
    public init(
        title: String,
        style: DialogButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public enum DialogButtonStyle {
    case primary
    case destructive
    case cancel
    
    var color: Color {
        switch self {
        case .primary: return .blue
        case .destructive: return .red
        case .cancel: return .gray
        }
    }
}
