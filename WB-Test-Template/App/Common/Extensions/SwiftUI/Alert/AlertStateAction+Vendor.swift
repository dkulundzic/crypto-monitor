import Foundation

extension AlertState.AlertAction {
    static func cancel(
        _ title: String = "Cancel",
        action: @escaping Action = { }
    ) -> Self {
        .init(
            title: title,
            role: .cancel,
            action: action
        )
    }

    static func regular(
        _ title: String,
        action: @escaping Action
    ) -> Self {
        .init(
            title: title,
            role: nil,
            action: action
        )
    }

    static func destructive(
        _ title: String,
        action: @escaping Action
    ) -> Self {
        .init(
            title: title,
            role: .destructive,
            action: action
        )
    }
}
