import Foundation

extension AlertState {
    static func error<Error>(
        _ error: Error,
        confirmation: @escaping Action,
        cancel: Action? = nil
    ) -> Self where Error: LocalizedError {
        .init(
            title: "Error", // TODO: Localize
            message: error.localizedDescription,
            actions: [
                .cancel {
                    cancel?()
                }
            ]
        )
    }
}
