import Foundation
import Combine
import Factory

public protocol LocalAppStorage: AnyObject {
    var lastAssetCacheUpdateDate: Date? { get set }
    var lastAssetCacheUpdateDatePublisher: AnyPublisher<Date?, Never> { get }
}

public final class DefaultLocalAppStorage: LocalAppStorage {
    public var lastAssetCacheUpdateDate: Date? {
        get {
            UserDefaults.standard.date(for: Key.lastAssetCacheUpdateDate.rawValue)
        }
        set {
            UserDefaults.standard.setDate(
                newValue, for: Key.lastAssetCacheUpdateDate.rawValue
            )
            lastAssetCacheUpdateDateSubject.send(newValue)
        }
    }

    public var lastAssetCacheUpdateDatePublisher: AnyPublisher<Date?, Never> {
        lastAssetCacheUpdateDateSubject
            .eraseToAnyPublisher()
    }

    private let lastAssetCacheUpdateDateSubject: CurrentValueSubject<Date?, Never>

    public init() {
        lastAssetCacheUpdateDateSubject = CurrentValueSubject<Date?, Never>(nil)
        lastAssetCacheUpdateDateSubject.value = lastAssetCacheUpdateDate
    }

    private enum Key: String {
        case lastAssetCacheUpdateDate
    }
}

public extension Container {
    var localAppStorage: Factory<LocalAppStorage> {
        self {
            DefaultLocalAppStorage()
        }.singleton
    }
}

// TODO: Move to Extensions folder
public extension UserDefaults {
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
