import Foundation

enum KnowledgeAndExperienceOption: String, CaseIterable, Identifiable, Hashable {
    case `none` = "NONE"
    case basic = "BASIC"
    case intermediate = "INTERMEDIATE"
    case advanced = "ADVANCED"

    var title: String {
        rawValue.lowercased().capitalized
    }
}

extension Identifiable where Self: RawRepresentable, RawValue == String {
    var id: RawValue {
        rawValue
    }
}
