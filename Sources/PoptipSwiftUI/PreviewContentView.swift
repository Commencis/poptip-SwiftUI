import SwiftUI

@MainActor
private enum Constant {

    static let previewTipTheme = PopTipTheme(
        bubbleColor: .gray,
        textColor: .white,
        font: .boldSystemFont(ofSize: 13),
        cornerRadius: 4,
        textAlignment: .left,
        overlayColor: .clear,
        edgeInsets: EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6),
        arrowSize: CGSize(width: 12, height: 6)
    )

    static let previewTipTheme2 = PopTipTheme(
        bubbleColor: .blue.opacity(0.9),
        textColor: .white,
        font: .systemFont(ofSize: 16, weight: .medium),
        cornerRadius: 20,
        textAlignment: .center,
        overlayColor: .black.opacity(0.4),
        edgeInsets: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        arrowSize: CGSize(width: 16, height: 8)
    )

    static let previewTipTheme3 = PopTipTheme(
        bubbleColor: .green.opacity(0.8),
        textColor: .yellow.opacity(0.9),
        font: .systemFont(ofSize: 14, weight: .semibold),
        cornerRadius: 10,
        textAlignment: .right,
        overlayColor: .black.opacity(0.5),
        edgeInsets: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10),
        arrowSize: CGSize(width: 10, height: 5)
    )
}

internal struct PreviewContentView: View {

    @State private var showPlainTip = false
    @State private var showTimerTip = false
    @State private var showCustomTip = false

    var body: some View {
        VStack(spacing: 40) {
            // Button 1: Plain PopTip with text
            Button("Show Plain PopTip") {
                showPlainTip.toggle()
            }
            .popTip(
                isPresented: $showPlainTip,
                message: "This is a simple PopTip!",
                theme: Constant.previewTipTheme
            )
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            // Button 2: PopTip with auto-dismiss timer
            Button("Show Timed PopTip") {
                showTimerTip.toggle()
            }

            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .popTip(
                isPresented: $showTimerTip,
                message: "This will dismiss in 2 seconds!",
                theme: Constant.previewTipTheme2,
                autoDismissDuration: 2.0
            )
            .popTipHasOverlayTargetHole(true)

            // Button 3: PopTip with custom SwiftUI content
            Button("Show Custom PopTip") {
                showCustomTip.toggle()
            }
            .popTip(
                isPresented: $showCustomTip,
                theme: Constant.previewTipTheme3
            ) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Custom Content!")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(8)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    PreviewContentView()
}
