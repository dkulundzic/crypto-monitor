import SwiftUI

private struct AlertModifier: ViewModifier {
    @Binding private var state: AlertState?

    init(
        state: Binding<AlertState?>
    ) {
        self._state = state
    }

    func body(
        content: Content
    ) -> some View {
        content.alert(
            state?.title ?? "",
            isPresented: .init(get: {
                state != nil
            }, set: { isPresented in
                if !isPresented {
                    state = nil
                }
            }),
            presenting: state
        ) { state in
            ForEach(
                state.actions
            ) { action in
                Button(
                    role: action.role,
                    action: action.action
                ) {
                    Text(action.title)
                }
            }
        } message: { state in
            Text(state.message)
        }
    }
}

extension View {
    func alert(
        state: Binding<AlertState?>
    ) -> some View {
        modifier(
            AlertModifier(
                state: state
            )
        )
    }
}
