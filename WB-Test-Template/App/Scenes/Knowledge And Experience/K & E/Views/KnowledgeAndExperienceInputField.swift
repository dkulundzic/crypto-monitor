import SwiftUI

struct KnowledgeAndExperienceInputField: View {
    let title: String
    let value: String
    let error: String?
    @Binding var item: KnowledgeAndExperienceItem
    let action: () -> Void

    private var color: Color {
        error == nil ? .black : .red
    }

    var body: some View {
        Button(
            action: action
        ) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(error ?? title)
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(color)
                    Text(value)
                        .font(.body)
                        .fontWeight(.bold)
                }
                Spacer()

                Image(systemName: "chevron.down")
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color)
                    .frame(maxWidth: .infinity)
            )
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    KnowledgeAndExperienceInputField(
        title: KnowledgeAndExperienceTopic.etcs.title,
        value: KnowledgeAndExperienceOption.advanced.title,
        error: nil,
        item: .constant(.init(topic: .bonds))
    ) {

    }
}
