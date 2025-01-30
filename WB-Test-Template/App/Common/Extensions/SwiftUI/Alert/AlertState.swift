import Foundation
import SwiftUI
import CryptoMonitorCore

struct AlertState: Equatable, Identifiable {
    var id: String {
        title
    }

    let title: String
    let message: String
    let actions: [AlertAction]

    init(
        title: String,
        message: String,
        actions: [AlertAction] = []
    ) {
        self.title = title
        self.message = message
        self.actions = {
            if actions.contains(where: { $0.role == .cancel }) {
                return actions
            } else {
                return [
                    actions, [
                        .init(
                            title: "Cancel", // TODO: Localize
                            role: .cancel,
                            action: { }
                        )
                    ]
                ].flatMap { $0 }
            }
        }()
    }

    init(
        title: String,
        message: String,
        onCancel: @escaping Action
    ) {
        self.title = title
        self.message = message
        self.actions = [
            .init(
                title: "Cancel", // TODO: Localize
                role: .cancel,
                action: onCancel
            )
        ]
    }

    struct AlertAction: Hashable, Identifiable {
        var id: String {
            title
        }

        let title: String
        let role: ButtonRole?
        let action: Action

        init(
            title: String,
            role: ButtonRole? = nil,
            action: @escaping Action
        ) {
            self.title = title
            self.role = role
            self.action = action
        }

        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(title)
        }

        static func == (
            lhs: AlertAction,
            rhs: AlertAction
        ) -> Bool {
            lhs.title == rhs.title
        }
    }
}
