import Foundation

protocol ViewModel: ObservableObject {
    associatedtype View: ActionableView
    func onAction(_ action: View.Action) async
}
