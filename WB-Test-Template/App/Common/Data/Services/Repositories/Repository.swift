import Foundation
import CoreData
import Factory
import CryptoMonitorModel

protocol Repository {
    associatedtype Model: ManagedObjectTransformable
    func fetch(id: String) async throws -> Model?
    func fetchAll() async throws -> [Model]
    func save(_ model: Model) async throws
    func save(_ models: [Model]) async throws
    func delete(_ id: String) async throws
}

protocol DomainObjectTransformable {
    associatedtype DomainModel
    func toDomain() -> DomainModel
}

protocol ManagedObjectTransformable {
    associatedtype ManagedModel: NSManagedObject
    func toManaged(using object: ManagedModel) -> ManagedModel
}

// TODO: Move to a more appropriate place
extension ExchangeRate: ManagedObjectTransformable {
    func toManaged(
        using object: ExchangeRateMO
    ) -> ExchangeRateMO {
        object.time = time
        object.rate = rate
        object.assetIdQuote = assetIdQuote
        return object
    }
}

// TODO: Move to a more appropriate place
extension Asset: ManagedObjectTransformable {
    func toManaged(
        using model: AssetMO
    ) -> AssetMO {
        model.assetId = assetId
        model.name = name
        model.dataQuoteStart = dataQuoteStart
        model.dataQuoteEnd = dataQuoteEnd
        model.dataOrderbookStart = dataOrderbookEnd
        model.dataTradeStart = dataTradeEnd
        model.typeIsCrypto = typeIsCrypto == 0 ? false : true
        model.dataSymbolsCount = Int64(dataSymbolsCount)
        model.volume1HrsUsd = volume1HrsUsd
        model.volume1DayUsd = volume1DayUsd
        model.volume1MthUsd = volume1MthUsd
        model.priceUsd = priceUsd ?? 0
        model.isFavorite = isFavorite
        model.iconUrl = iconUrl
        return model
    }
}
