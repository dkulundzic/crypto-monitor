// KnowledgeAndExperienceView.swift

import SwiftUI

// swiftlint:disable line_length
struct KnowledgeAndExperienceView: View {
    private let text: String = "Please indicate  for each product group how many transactions you have already carried out yourself in the past 3 years, i.e., without the support of an asset manager or  investment advisor."

    @StateObject var viewModel = KnowledgeAndExperienceViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Experience")
                        .font(.title)
                        .fontWeight(.bold)

                    Text(text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }

                VStack(alignment: .leading) {
                    ForEach(
                        $viewModel.items, id: \.self
                    ) { $item in
                        KnowledgeAndExperienceInputField(
                            title: item.topic.title,
                            value: item.selectedOption?.title ?? "Please select...",
                            error: item.error,
                            item: $item
                        ) {
                            viewModel.onInputFieldTapped(for: item)
                        }
                    }
                }

                Text("Please provide information from the perspective of the authorized representative with the lowest level of knowledge and experience.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }

            VStack {
                Button {
                    viewModel.onSubmitButtonTapped()
                } label: {
                    Text("Submit and Start Trading")
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue)
                )

                Button {

                } label: {
                    Text("Logout")
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue)
                )
            }
        }
        .padding()
        .sheet(
            item: $viewModel.sheet
        ) { sheet in
            switch sheet {
            case let .topicOptionInput(item, itemIndex):
                KnowledgeAndExperienceOptionSheet(
                    title: item.topic.rawValue,
                    option: $viewModel.items[itemIndex][keyPath: \.selectedOption]
                ) {
                    viewModel.onOptionSheetCloseButtonTapped()
                }
                .presentationDetents([.height(330)])
            }
        }
        .animation(.spring, value: viewModel.items)
    }
}

#Preview {
    KnowledgeAndExperienceView()
}
