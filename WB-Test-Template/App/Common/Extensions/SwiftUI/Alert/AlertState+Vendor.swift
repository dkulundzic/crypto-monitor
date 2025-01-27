import Foundation

extension AlertState {
    static func error<Error>(
        _ error: Error,
        retry: Action? = nil,
        cancel: Action? = nil
    ) -> Self where Error: LocalizedError {
        Self.error(
            error.localizedDescription,
            retry: retry,
            cancel: cancel
        )
    }

    static func error(
        _ error: String,
        retry: Action? = nil,
        cancel: Action? = nil
    ) -> Self {
        .init(
            title: "Error", // TODO: Localize
            message: error,
            actions: [
                retry == nil ? nil: .regular("Retry") {
                    retry?()
                },
                .cancel {
                    cancel?()
                }
            ].compactMap { $0 }
        )
    }
}
