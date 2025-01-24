import Foundation

enum NetworkServiceRetryPolicy {
    case `default`
    case never

    var maxRetryCount: Int {
        switch self {
        case .default:
            3
        case .never:
            1
        }
    }

    var retryDelay: TimeInterval {
        switch self {
        case .default:
            2
        case .never:
            0
        }
    }
}
