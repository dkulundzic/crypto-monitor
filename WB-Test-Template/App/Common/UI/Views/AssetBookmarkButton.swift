import SwiftUI

struct AssetBookmarkButton: View {
    @Binding var isBookmarked: Bool

    var body: some View {
        Button {
            isBookmarked.toggle()
        } label: {
            Text(isBookmarked ? "Remove asset bookmark" : "Bookmark asset")
        }
    }
}
