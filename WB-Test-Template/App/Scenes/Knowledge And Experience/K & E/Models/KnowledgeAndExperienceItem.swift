import Foundation

struct KnowledgeAndExperienceItem: Hashable {
    let topic: KnowledgeAndExperienceTopic
    var selectedOption: KnowledgeAndExperienceOption? {
        didSet { validate() }
    }
    var error: String?

    var isValid: Bool {
        error == nil
    }

    mutating func validate() {
        error = selectedOption == nil ? "Required: \(topic.title)" : nil
    }
}

extension KnowledgeAndExperienceItem: Identifiable {
    var id: KnowledgeAndExperienceTopic {
        topic
    }
}

extension KnowledgeAndExperienceItem: CaseIterable {
    static var allCases: [KnowledgeAndExperienceItem] {
        KnowledgeAndExperienceTopic.allCases.map {
            KnowledgeAndExperienceItem(topic: $0)
        }
    }
}
