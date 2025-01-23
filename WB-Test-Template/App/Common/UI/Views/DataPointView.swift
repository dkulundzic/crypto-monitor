import SwiftUI

struct DataPointView: View {
    let title: String
    let detail: String
    var layout = DynamicStackLayout.vertical

    var body: some View {
        DynamicStack(
            spacing: 4,
            layout: layout
        ) {
            Text(title)
                .foregroundStyle(.secondary)
                .font(.callout)
                .fontWeight(.medium)

            if layout == .horizontal {
                Spacer()
            }

            Text(detail)
                .foregroundStyle(.foreground)
                .font(.callout)
                .fontWeight(.light)
        }
    }
}

#Preview {
    DataPointView(
        title: "BTC",
        detail: "0.321031203010"
    )
    .padding()
}
