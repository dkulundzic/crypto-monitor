// KnowledgeAndExperienceViewModel.swift

import SwiftUI
import Combine

typealias KnowledgeAndExperienceResult = KnowledgeAndExperienceViewModel.Result

final class KnowledgeAndExperienceViewModel: ObservableObject {
    @Published var sheet: Sheet?
    @Published var items = KnowledgeAndExperienceItem.allCases
    private var bag = Set<AnyCancellable>()
    private let onResult: (KnowledgeAndExperienceResult) -> Void

    init(
        onResult: @escaping (KnowledgeAndExperienceResult) -> Void
    ) {
        self.onResult = onResult
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

    enum Result {
        case successfullySubmit
        case logoutRequested
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

    @MainActor
    func onSubmitButtonTapped() {
        items = items.map { item in
            var item = item
            item.validate()
            return item
        }

        guard items.allSatisfy(\.isValid) else {
            return
        }

        Task {
            try await Task.sleep(for: .seconds(1))
            onResult(.successfullySubmit)
        }
    }

    func onLogoutButtonTapped() {
        onResult(.logoutRequested)
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
