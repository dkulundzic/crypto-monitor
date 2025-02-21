import Foundation
import CryptoMonitorCore
import CryptoMonitorLocalization

extension AlertState.AlertAction {
    static func cancel(
        _ title: String = L10n.alertActionCancel,
        action: @escaping Action = { }
    ) -> Self {
        .init(
            title: title,
            role: .cancel,
            action: action
        )
    }

    static func casualCancel(
        _ title: String = L10n.alertActionCasualCancel,
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
