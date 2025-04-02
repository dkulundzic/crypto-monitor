import Foundation

enum KnowledgeAndExperienceTopic: String, CaseIterable, Identifiable, Hashable {
    case etfs
    case bonds
    case etcs
    case derivatives

    var title: String {
        switch self {
        case .etfs:
            "Investment-Funds/ETFs"
        case .bonds:
            "Bonds"
        case .etcs:
            "ETC/ETP/ETNs"
        case .derivatives:
            "Certificates/Derivatives"
        }
    }
}
