import SwiftUI
import CryptoMonitorLocalization

struct OfflineBannerView: View {
    var body: some View {
        VStack {
            Divider()

            Text(L10n.messageOffline)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .background()
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    OfflineBannerView()
}
