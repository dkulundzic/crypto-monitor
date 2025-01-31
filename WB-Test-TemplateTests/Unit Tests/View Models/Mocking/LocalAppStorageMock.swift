import Foundation
import Combine
import CryptoMonitorCore

final class LocalAppStorageMock: LocalAppStorage {
    private static let fixedDate = Calendar.current.date(
        from: .init(
            year: 2020,
            month: 1,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0
        )
    )

    var lastAssetCacheUpdateDate: Date? {
        get { Self.fixedDate }
        set { }
    }

    var lastAssetCacheUpdateDatePublisher: AnyPublisher<Date?, Never> {
        Just(Self.fixedDate)
            .eraseToAnyPublisher()
    }
}
