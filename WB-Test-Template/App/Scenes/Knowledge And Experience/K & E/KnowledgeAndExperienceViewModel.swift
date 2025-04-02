// KnowledgeAndExperienceViewModel.swift

import SwiftUI
import Combine

final class KnowledgeAndExperienceViewModel: ObservableObject {
    @Published var sheet: Sheet?
    @Published var items = KnowledgeAndExperienceItem.allCases
    private var bag = Set<AnyCancellable>()

    init() {
        setupObserving()
    }

    enum Sheet: Hashable, Identifiable {
        case topicOptionInput(KnowledgeAndExperienceItem, Int)

        var id: String {
            switch self {
            case let .topicOptionInput(item, _):
                item.topic.id
            }
        }
    }
}

extension KnowledgeAndExperienceViewModel {
    func onInputFieldTapped(
        for item: KnowledgeAndExperienceItem
    ) {
        if let itemIndex = items.firstIndex(of: item) {
            sheet = .topicOptionInput(item, itemIndex)
        }
    }

    func onOptionSheetCloseButtonTapped() {
        sheet = nil
    }

    func onSubmitButtonTapped() {
        items = items.map { item in
            var item = item
            item.validate()
            return item
        }

        guard items.allSatisfy(\.isValid) else {
            return
        }

        print("Proceed to network request.")
    }
}

private extension KnowledgeAndExperienceViewModel {
    func setupObserving() {
        $items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.sheet = nil
            }
            .store(in: &bag)
    }
}
