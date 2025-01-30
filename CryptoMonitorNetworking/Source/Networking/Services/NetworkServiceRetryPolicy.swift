import Foundation

public enum NetworkServiceRetryPolicy {
    case `default`
    case never

    public var maxRetryCount: Int {
        switch self {
        case .default:
            3
        case .never:
            1
        }
    }

    public var retryDelay: TimeInterval {
        switch self {
        case .default:
            2
        case .never:
            0
        }
    }
}
