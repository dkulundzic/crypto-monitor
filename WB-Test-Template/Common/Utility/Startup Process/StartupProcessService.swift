import Foundation

final class StartupProcessService {
    @discardableResult
    func execute(
        _ process: StartupProcess
    ) -> Self {
        process.run()
        return self
    }
}
