import SwiftUI

struct KnowledgeAndExperienceOptionSheet: View {
    let title: String
    @Binding var option: KnowledgeAndExperienceOption?
    let closeAction: () -> Void

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 19
        ) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: closeAction) {
                    Image(systemName: "x.circle")
                }
            }

            List(
                KnowledgeAndExperienceOption.allCases
            ) { option in
                Button {
                    self.option = option
                } label: {
                    HStack(
                        spacing: 20
                    ) {
                        option.icon
                        Text(option.sheetTitle)
                            .padding(.vertical, 16)
                        Spacer()

                        if self.option == option {
                            Image(systemName: "checkmark")
                                .imageScale(.small)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(.zero))
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
    }
}

#Preview {
    KnowledgeAndExperienceOptionSheet(
        title: "Bonds",
        option: .constant(.advanced)
    ) { }
}

private extension KnowledgeAndExperienceOption {
    var sheetTitle: String {
        switch self {
        case .none:
            "No transactions"
        case .basic:
            "1-3 transaction"
        case .intermediate:
            "4-9 transaction"
        case .advanced:
            "10+ transaction"
        }
    }

    var icon: Image {
        switch self {
        case .none:
            Image(systemName: "line.3.horizontal")
        case .basic:
            Image(systemName: "line.3.horizontal")
        case .intermediate:
            Image(systemName: "line.3.horizontal")
        case .advanced:
            Image(systemName: "line.3.horizontal")
        }
    }
}
