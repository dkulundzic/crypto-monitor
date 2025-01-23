import SwiftUI

enum DynamicStackLayout {
    case horizontal
    case vertical
}

struct DynamicStack<Content>: View where Content: View {
    var horizontalAlignment = HorizontalAlignment.leading
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    var layout: DynamicStackLayout
    @ViewBuilder var content: () -> Content

    var body: some View {
        Group {
            switch layout {
            case .horizontal:
                HStack(
                    alignment: verticalAlignment,
                    spacing: spacing,
                    content: content
                )
            case .vertical:
                VStack(
                    alignment: horizontalAlignment,
                    spacing: spacing,
                    content: content
                )
            }
        }
    }
}
