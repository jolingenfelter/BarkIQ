//
//  AlertModel.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct AlertModel: Equatable {
    let title: String
    let message: String
    let actions: [Action]

    struct Action {
        let title: String
        let action: () -> Void
        let role: ButtonRole?

        init(_ title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
            self.title = title
            self.action = action
            self.role = role
        }

        static let ok = Action("ok", action: {})
        static let cancel = Action("cancel", role: .cancel, action: {})

        static func ok(_ action: @escaping () -> Void) -> Action {
            Action("ok", action: action)
        }
    }

    static func == (_: AlertModel, _: AlertModel) -> Bool {
        false // no way to compare action closures
    }
}

private struct AlertModelModifier: ViewModifier {
    private(set) var model: Binding<AlertModel?>

    private var isAlertPresented: Binding<Bool> {
        Binding(get: {
            model.wrappedValue != nil
        }, set: { newValue in
            if newValue == false, model.wrappedValue != nil {
                model.wrappedValue = nil
            }
        })
    }

    func body(content: Content) -> some View {
        content
            .alert(
                model.wrappedValue?.title ?? "",
                isPresented: isAlertPresented,
                presenting: model.wrappedValue
            ) { model in
                ForEach(model.actions, id: \.title) { action in
                    Button(action.title, role: action.role, action: action.action)
                }
            } message: { model in
                Text(model.message)
            }
    }
}

extension View {
    func alert(_ model: Binding<AlertModel?>) -> some View {
        modifier(AlertModelModifier(model: model))
    }
}

// in-view Usage:
// .alert($viewModel.resendVerificationAlert)

private struct AlertModifierPreviewView: View {
    @State var model: AlertModel?

    var body: some View {
        VStack {
            Spacer()
            Button("Show Alert") {
                model = .init(
                    title: "Error",
                    message: "Unknown error",
                    actions: [.ok]
                )
                
                Task {
                    // Verify that it can programmatically dismiss
                    try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    model = nil
                }
            }
            Spacer()
        }
        .alert($model)
    }
}

#Preview {
    AlertModifierPreviewView()
}
