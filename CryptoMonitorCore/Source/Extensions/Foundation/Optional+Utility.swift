import Foundation

public extension Optional where Wrapped == String {
    var emptyIfNil: String {
        switch self {
        case .none:
            ""
        case .some(let string):
            string
        }
    }
}
