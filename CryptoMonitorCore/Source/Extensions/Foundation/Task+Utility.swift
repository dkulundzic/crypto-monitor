import Foundation

public extension Task where Failure == Error {
    @discardableResult
    static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        retryDelay: TimeInterval = 1,
        condition: @Sendable @escaping (Error) -> Bool = { _ in true },
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(
            priority: priority
        ) {
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    if condition(error) {
                        let oneSecond = TimeInterval(1_000_000_000)
                        let delay = UInt64(oneSecond * retryDelay)
                        try await Task<Never, Never>.sleep(nanoseconds: delay)
                        continue
                    } else {
                        throw error
                    }
                }
            }

            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
