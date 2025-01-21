import Foundation

final class StartupProcessService {
    func execute(
        _ process: StartupProcess
    ) -> Self {
        process.run()
        return self
    }
}
