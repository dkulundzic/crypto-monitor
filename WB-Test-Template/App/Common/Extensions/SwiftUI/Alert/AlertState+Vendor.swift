import Foundation

extension AlertState {
    static func error<Error>(
        _ error: Error,
        confirmation: @escaping Action,
        cancel: Action? = nil
    ) -> Self where Error: LocalizedError {
        Self.error(
            error.localizedDescription,
            confirmation: confirmation,
            cancel: cancel
        )
    }

    static func error(
        _ error: String,
        confirmation: @escaping Action,
        cancel: Action? = nil
    ) -> Self {
        .init(
            title: "Error", // TODO: Localize
            message: error,
            actions: [
                .regular("Retry") {
                    confirmation()
                },
                .casualCancel {
                    cancel?()
                }
            ]
        )
    }
}
