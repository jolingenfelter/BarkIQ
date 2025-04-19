//
//  ConfirmationDialogModel.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct ConfirmationDialogModel: Equatable {
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
    }

    static func == (_: ConfirmationDialogModel, _: ConfirmationDialogModel) -> Bool {
        false // no way to compare action closures
    }
}

private struct ConfirmationDialogModifier: ViewModifier {
    private(set) var model: Binding<ConfirmationDialogModel?>

    private var isPresented: Binding<Bool> {
        Binding {
            model.wrappedValue != nil
        } set: { newValue in
            if newValue == false, model.wrappedValue != nil {
                model.wrappedValue = nil
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .confirmationDialog(model.wrappedValue?.title ?? "",
                                isPresented: isPresented,
                                titleVisibility: model.wrappedValue?.title != nil ? .visible : .hidden,
                                presenting: model.wrappedValue) { model in
                ForEach(model.actions, id: \.title) { action in
                    Button(action.title, role: action.role, action: action.action)
                }
            } message: { model in
                Text(model.message)
            }
    }
}

extension View {
    func confirmationDialog(_ model: Binding<ConfirmationDialogModel?>) -> some View {
        modifier(ConfirmationDialogModifier(model: model))
    }
}

// in-view Usage:
// .confirmationDialog($confirmation)

struct ConfirmationDialogPreviewView: View {
    @State var model: ConfirmationDialogModel?

    var body: some View {
        VStack {
            Spacer()
            Button("Show Confirmation Dialog") {
                let action = ConfirmationDialogModel.Action("Confirm", role: .destructive, action: {})
                
                model = .init(
                    title: "Are you sure you want to quit?",
                    message: "Your progress will not be saved.",
                    actions: [action]
                )
            }
            Spacer()
        }
        .confirmationDialog($model)
    }
}

struct ConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogPreviewView()
    }
}
