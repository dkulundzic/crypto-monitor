import Foundation
import Combine
import Factory

protocol LocalAppStorage {
    var lastAssetCacheUpdateDate: Date? { get set }
    var lastAssetCacheUpdateDatePublisher: AnyPublisher<Date?, Never> { get }
}

final class DefaultLocalAppStorage: LocalAppStorage {
    var lastAssetCacheUpdateDate: Date? {
        get {
            UserDefaults.standard.date(for: Key.lastAssetCacheUpdateDate.rawValue)
        }
        set {
            UserDefaults.standard.setDate(
                newValue, for: Key.lastAssetCacheUpdateDate.rawValue
            )
        }
    }

    var lastAssetCacheUpdateDatePublisher: AnyPublisher<Date?, Never> {
        lastAssetCacheUpdateDateSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private let lastAssetCacheUpdateDateSubject = PassthroughSubject<Date?, Never>()

    init() {
        lastAssetCacheUpdateDateSubject.send(lastAssetCacheUpdateDate)
    }

    private enum Key: String {
        case lastAssetCacheUpdateDate
    }
}

extension Container {
    var localAppStorage: Factory<LocalAppStorage> {
        self {
            DefaultLocalAppStorage()
        }.singleton
    }
}

extension UserDefaults {
    func setDate(
        _ date: Date?,
        for key: String
    ) {
        Self.standard.set(date?.timeIntervalSince1970, forKey: key)
    }

    func date(for key: String) -> Date? {
        guard
            let date = Self.standard.object(
                forKey: key
            ) as? Double
        else {
            return nil
        }

        return Date(timeIntervalSince1970: date)
    }
}
