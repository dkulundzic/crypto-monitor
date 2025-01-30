import Foundation

public final class StartupProcessService {
    public init() { }

    @discardableResult
    public func execute(
        _ process: StartupProcess
    ) -> Self {
        process.run()
        return self
    }
}
